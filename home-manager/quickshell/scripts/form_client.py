"""Display a JSON form; pass submitted values as JSON stdin to an argv callback."""

import json
import os
import subprocess
import sys
import time
import uuid


def ipc(method, *args):
    result = subprocess.run(
        [
            os.environ["QUICKSHELL"],
            "-c",
            "lurian",
            "ipc",
            "call",
            "forms",
            method,
            *args,
        ],
        capture_output=True,
        text=True,
        timeout=5,
        check=True,
    )
    return result.stdout.strip()


def main():
    if len(sys.argv) < 2:
        sys.exit("Usage: quickshell-form FORM.json [CALLBACK ARG ...]")
    with open(sys.argv[1]) as source:
        definition = json.load(source)
    callback = sys.argv[2:]
    subprocess.run(
        [os.environ["SYSTEMCTL"], "--user", "start", "quickshell.service"], check=True
    )
    for attempt in range(50):
        try:
            if ipc("ping") == "ready":
                break
        except (subprocess.SubprocessError, OSError):
            pass
        time.sleep(0.1)
    else:
        sys.exit("Quickshell form service did not become ready")
    request = str(uuid.uuid4())
    if ipc("open", request, json.dumps(definition)) != "ok":
        sys.exit("A form is already open, or the form definition is invalid")
    try:
        while True:
            result = json.loads(ipc("poll", request))
            if result["state"] in ("cancelled", "missing"):
                return 1
            if result["state"] == "submitted":
                values = json.dumps(result["values"])
                if not callback:
                    print(values)
                    ipc("finish", request, "")
                    return 0
                process = subprocess.Popen(
                    callback,
                    stdin=subprocess.PIPE,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                )
                process.stdin.write(values)
                process.stdin.close()
                process.stdin = None
                while True:
                    try:
                        stdout, stderr = process.communicate(timeout=0.5)
                        break
                    except subprocess.TimeoutExpired:
                        # Keep the request alive while the callback is running.
                        try:
                            ipc("poll", request)
                        except (subprocess.SubprocessError, OSError):
                            # A dismissed/crashed UI does not cancel an applied command.
                            stdout, stderr = process.communicate()
                            return process.returncode
                error = (
                    (stderr or stdout or "Command failed") if process.returncode else ""
                )
                state = ipc("finish", request, error[-8000:])
                if not error or state == "dismissed":
                    return process.returncode
            time.sleep(0.2)
    finally:
        try:
            ipc("release", request)
        except (subprocess.SubprocessError, OSError):
            pass


if __name__ == "__main__":
    sys.exit(main())

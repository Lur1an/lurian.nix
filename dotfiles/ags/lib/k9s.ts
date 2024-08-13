import options from 'options';
import { dump } from 'js-yaml';

const deps = ['k9sSkin'];

async function setupK9s() {
    const skin = options.k9sSkin.value;
    try {
        await Utils.writeFile(
            dump(skin),
            '/home/lurian/.config/k9s/skins/matugen.yaml'
        );
    } catch (error) {
        console.error(`Failed to serialize and write k9s skin: ${error}`);
    }
}

export default function init() {
    options.handler(deps, setupK9s);
    setupK9s();
}

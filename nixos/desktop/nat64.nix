{...}: {
  networking = {
    useNetworkd = true;
    useDHCP = false;
    nameservers = [
      "2a00:1098:2b::1"
      "2a00:1098:2c::1"
      "2a01:4f8:c2c:123f::1"
    ];
    enableIPv6 = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = ["~."];
    fallbackDns = [
      "2a00:1098:2b::1"
      "2a00:1098:2c::1"
      "2a01:4f8:c2c:123f::1"
    ];
    extraConfig = ''
      DNS=2a00:1098:2b::1 2a00:1098:2c::1 2a01:4f8:c2c:123f::1
      DNSOverTLS=no
    '';
  };

  # Rest of your configuration...
}

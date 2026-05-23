{ config, pkgs, ... }:

{
	networking.hostName = "nixos"; # Define your hostname.
	networking.networkmanager.enable = true;
	networking.firewall = {
		enable = true;
		allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
		allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
	};
	# networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
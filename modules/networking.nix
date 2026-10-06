{ config, pkgs, ... }:

{
	networking.hostName = "nixos"; # Define your hostname.
	networking.networkmanager.enable = true;

	# networking.networkmanager.wifi.backend = "iwd";
	# networking.wireless.enable = false;
	# networking.wireless.iwd = {
  # enable = true;
  # settings = {
  #   Settings = {
  #     AutoConnect = true;
  #   };
  # };

	networking.firewall = {
		enable = true;
		# checkReversePath = false;
		allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
		allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPorts = [ 9993 config.services.tailscale.port ];
		allowedTCPPorts = [ 7897 1701 ];
		trustedInterfaces = [ "Mihomo" "Meta" "wt0" "zt+" "tailscale0" ];
		extraReversePathFilterRules = ''
			iifname { "Mihomo", "Meta", "wt0", "zt+" } accept comment "clash-verge tun traffic"
		'';
	};
	networking.nat = {
		enable = true;
		# Укажите имя вашего сетевого интерфейса (Ethernet/Wi-Fi). Его можно узнать на ПК командой: ip route show | grep default
		externalInterface = "wlp0s20f3"; 
		# internalInterfaces = [ "zt+" ];
	};
	# networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
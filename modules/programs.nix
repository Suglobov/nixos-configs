{ pkgs, ... }:

{
	# Базовый системный софт
	environment.systemPackages = with pkgs; [
		vim
		wget
		git
		curl
		fish
		yazi
		home-manager
		xwayland-satellite
		amneziawg-tools
		amnezia-vpn
	];

	# Системные оболочки и композиторы (требуют интеграции с PAM/SUID)
	programs.niri.enable = true;
	programs.fish.enable = true;
	programs.hyprlock.enable = true;
}

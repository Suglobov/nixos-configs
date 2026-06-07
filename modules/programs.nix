{ pkgs, ... }:

{
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
		fuse
		fuse3
	];

	programs.niri.enable = true;
	programs.fish.enable = true;
	programs.hyprlock.enable = true;
	programs.nix-ld.enable = true;
	programs.fuse.userAllowOther = true;
	programs.clash-verge = {
		enable = true;
		serviceMode = true; # Настраивает системную службу
		tunMode = true; # Выдает setcap-права для создания TUN-интерфейса
	};
}

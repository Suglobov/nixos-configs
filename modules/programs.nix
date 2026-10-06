{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		vim
		neovim
		wget
		git
		curl
		fish
		yazi
		home-manager
		# amneziawg-tools
		# amnezia-vpn
		fuse
		fuse3
		at-spi2-core
		xwayland-satellite	# xwayland для wayland без root (0.8.2 из flake, см. overlay в flake.nix)
	];
	environment.sessionVariables = {
		# QS_ICON_THEME = "Tela";
	};


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
	programs.ydotool.enable = true;
}

{ config, pkgs, lib, inputs, username, ... }:
{
	imports = [
		./home/symlinks.nix
		./home/programs.nix
		./home/services.nix
	];

	programs.home-manager.enable = true;

	home.username = username;
	home.homeDirectory = "/home/${username}";
	home.stateVersion = "24.11";

	gtk = {
		enable = true;
		iconTheme = {
			name = "Kanagawa";
		# 	package = pkgs.tela-icon-theme;
		};
	};

	qt = {
		enable = true;
		platformTheme.name = "gtk3";
		# style.name = "adwaita";
	};

	home.sessionVariables = {
		MOZ_ENABLE_WAYLAND = "1";
		# GTK_USE_PORTAL = "1";
		# QS_ICON_THEME = "Papirus";
		# XCURSOR_THEME = "Banana";
		# XCURSOR_SIZE = "60";
	};
}

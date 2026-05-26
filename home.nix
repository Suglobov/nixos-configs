{ osConfig, config, pkgs, lib, inputs, ... }:
{
	imports = [
		./home/symlinks.nix
		./home/programs.nix
		./home/services.nix
	];

	programs.home-manager.enable = true;

	home.username = "eugeny";
	home.homeDirectory = "/home/eugeny";
	home.stateVersion = "24.11";
	home.sessionVariables = {
		MOZ_ENABLE_WAYLAND = "1";
		GDK_BACKEND = "wayland,x11";
		XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share";
		#XDG_DATA_DIRS = pkgs.lib.mkForce "${NIX_STATE_DIR:-/nix/var/nix}/profiles/default/share:$HOME/.nix-profile/share:/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}";
		#GTK_THEME = "Adwaita";
		QT_QPA_PLATFORMTHEME = "gtk3";
		XDG_CURRENT_DESKTOP = "Noctalia";
	};
}

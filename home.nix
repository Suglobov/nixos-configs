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
			name = "Papirus"; 
			package = pkgs.papirus-icon-theme;
		};
	# 	gtk4.theme = null;
		# theme = {
		# 	name = "Adwaita"; # Стандартная тема, которая сама переключается светлая/темная
		# 	# package = pkgs.gnome.gnome-themes-extra;
		# };
	# 	gtk3.extraConfig.gtk-icon-theme-name = "Papirus";
	};

	# qt = {
	# 	enable = true;
	# 	platformTheme.name = "gtk";
	# 	style.name = "adwaita";
	# };

	home.sessionVariables = {
		MOZ_ENABLE_WAYLAND = "1";
		# QS_ICON_THEME = "Papirus";
		# GDK_BACKEND = "wayland,x11";
		# XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.local/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS";
		# XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.local/share:/run/current-system/sw/share:$XDG_DATA_DIRS";
		# XDG_CURRENT_DESKTOP = "Noctalia";
		# QT_MINIMAL_SETTINGS_PROVIDER = "none";
		# QT_USE_PORTAL = "1";
		# XDG_RUNTIME_DIR = "/run/user/1000";
		# XCURSOR_THEME = "Banana";
  	# XCURSOR_SIZE = "60";
	};

	# dconf.settings = {
	# 	"org/gnome/desktop/interface" = {
	# 		cursor-theme = "Banana";
	# 		cursor-size = 60;
	# 	};
	# };

	# xdg.terminal-exec = {
	# 	enable = true;
	# 	settings = {
	# 		default = [ "foot.desktop" ];
	# 		Noctalia = [ "foot.desktop" ];
	# 	};
	# };
	# xdg.desktopEntries.yazi = {
	# 	name = "Yazi";
	# 	exec = "yazi %u";
	# 	mimeType = [ "inode/directory" ];
	# 	terminal = true; # Важно! Указывает xdg-terminal-exec, что приложение требует терминал
	# 	type = "Application";
	# 	categories = [ "System" "FileTools" "FileManager" ];
	# };
	# xdg.mimeApps = {
	# 	enable = true;
	# 	defaultApplications = {
	# 		"application/x-ms-dos-executable" = [ "ru.linux_gaming.PortProton" ];
	# 		"application/x-msi" = [ "ru.linux_gaming.PortProton" ];
	# 		"application/x-ms-shortcut" = [ "ru.linux_gaming.PortProton" ];
	# 		"application/x-wine-extension-exe" = [ "ru.linux_gaming.PortProton" ];
	# 		"application/x-executable" = [ "ru.linux_gaming.PortProton" ];

	# 		"inode/directory" = [ "org.kde.dolphin.desktop" ];
	# 		# "inode/directory" = [ "yazi.desktop" ];
	# 		# "inode/directory" = [ "thunar.desktop" ];
	# 	};
	# };
}

{ config, pkgs, inputs, ... }:
{
	home.username = "eugeny";
	home.homeDirectory = "/home/eugeny";
	home.stateVersion = "24.11";

	programs.home-manager.enable = true;

	# Этот трюк намертво прячет автозапуск blueman-applet в вашей Wayland-сессии
	# xdg.configFile."autostart/blueman.desktop".text = ''
	#   [Desktop Entry]
	#   Hidden=true
	# '';

	home.sessionVariables = {
		MOZ_ENABLE_WAYLAND = "1";
		GDK_BACKEND = "wayland,x11";
		XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share";
		#XDG_DATA_DIRS = pkgs.lib.mkForce "${NIX_STATE_DIR:-/nix/var/nix}/profiles/default/share:$HOME/.nix-profile/share:/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}";
		#GTK_THEME = "Adwaita";
		QT_QPA_PLATFORMTHEME = "gtk3";
		XDG_CURRENT_DESKTOP = "Noctalia";
	};

	/*home.sessionPath = [
		"$HOME/.nix-profile/bin"
	];*/

	programs.chromium = {
		enable = true;
		package = (config.lib.nixGL.wrap pkgs.google-chrome);
		commandLineArgs = [
			"--ozone-platform-hint=wayland"
			"--enable-features=WaylandWindowDecorations"
		];
	};

	programs.vscode = {
		enable = true;
		package = (pkgs.vscode.override {
			# Передаем параметры Wayland и заставляем Electron принудительно искать курсоры в системе
			commandLineArgs = "--ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations";
		});
	};

	services.flatpak = {
		enable = true;
		uninstallUnmanaged = false; # Удалять ли приложения, не объявленные в этом списке (по желанию):
		remotes = [{
			name = "flathub";
			location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
		}];
		packages = [
			# "org.telegram.desktop"
			"com.github.tchx84.Flatseal"
			"ru.linux_gaming.PortProton"
			"io.github.flattool.Warehouse"
		];
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		dotDir = config.home.homeDirectory;
	};
	programs.starship = {
		enable = true;
		settings = {
			add_newline = false;
			character = {
				success_symbol = "[➜](bold green)";
				error_symbol = "[➜](bold red)";
			};
		};
	};

	 home.packages = with pkgs; [
		inputs.noctalia.packages.${pkgs.system}.default
		inputs.fresh.packages.${pkgs.system}.default
		kdePackages.dolphin
		kdePackages.konsole
		flatpak
		git
		fuzzel
		fzf
		ripgrep
		fd
		zoxide
		bat
		eza
		direnv
		jq
		wget
		curl
		tmux
		ghostty
		yazi
		neovim
		firefox
		# obs-studio
		vlc
		lazygit
		fish
		grim
		slurp
		satty
		wl-clipboard
		wf-recorder
		btop
		niri
		thunar
		dbeaver-bin
		foot
		telegram-desktop
		papirus-icon-theme
		gtklock
		appimage-run
	];
}

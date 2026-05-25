{ config, pkgs, lib, inputs, ... }:
{
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

	home.activation.portprotonPrefixesSymlink =
		lib.hm.dag.entryAfter [ "writeBoundary" ] ''
			prefixLink="/home/eugeny/.var/app/ru.linux_gaming.PortProton/data/prefixes"
			prefixTarget="/home/eugeny/data/PortProton/prefixes"

			mkdir -p "$prefixTarget"

			if [ -e "$prefixLink" ] && [ ! -L "$prefixLink" ]; then
				rm -rf "$prefixLink"
			fi

			ln -sfn "$prefixTarget" "$prefixLink"
		'';

	home.activation.multiSymlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] (
		let
			names = [ "niri" "noctalia" "fuzzel" "fish" "yazi" "hypr" ];
			homeDir = config.home.homeDirectory;
			symlinks = map (name: {
				link = "${homeDir}/.config/${name}";
				target = "${homeDir}/nixos/.config/${name}";
			}) names;
		in
		lib.concatMapStringsSep "\n" (item: ''
			linkPath="${item.link}"
			targetPath="${item.target}"
			mkdir -p "$targetPath"
			if [ -e "$linkPath" ] && [ ! -L "$linkPath" ]; then
				rm -rf "$linkPath"
			fi
			ln -sfn "$targetPath" "$linkPath"
		'') symlinks
	);

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
			location = "https://flathub.org/repo/flathub.flatpakrepo";
		}];
		packages = [
			# "org.telegram.desktop"
			"com.github.tchx84.Flatseal"
			"ru.linux_gaming.PortProton"
			"io.github.flattool.Warehouse"
		];
	};

	services.kdeconnect = {
		enable = true;
		# indicator = true; 
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
		enableFishIntegration = true;
		settings = {
			add_newline = false;
			character = {
				success_symbol = "[➜](bold green)";
				error_symbol = "[➜](bold red)";
			};
		};
	};

	 home.packages = with pkgs; [
		(appimage-run.override {
			extraPkgs = pkgs: [ 
				pkgs.libepoxy 
			];
		})
		# appimage-run
		inputs.noctalia.packages.${pkgs.system}.default
		inputs.fresh.packages.${pkgs.system}.default
		kdePackages.dolphin
		kdePackages.konsole
		flatpak
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
		p7zip
		# warp-terminal
		# flclash
		duf
		dysk
		warp
		nsxiv
		# nekoray
		# clash-verge-rev
	];
}

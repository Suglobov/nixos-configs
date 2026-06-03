{ config, pkgs, inputs, username, ... }:
{
	services.flatpak = {
		enable = true;
		uninstallUnmanaged = false;
		remotes = [{
			name = "flathub";
			location = "https://flathub.org/repo/flathub.flatpakrepo";
		}];
		packages = [
			"com.github.tchx84.Flatseal"
			"io.github.flattool.Warehouse"
			"ru.linux_gaming.PortProton"
			"com.valvesoftware.Steam"
			"no.mifi.losslesscut"
		];
		overrides.settings = {
			global = {
				Environment = {
					XCURSOR_THEME = "Banana";
					XCURSOR_SIZE = "60";
					# XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons:~/.icons";
				};
				Context.filesystems = [
					"~/.icons:ro"
					# "/run/current-system/sw/share/icons:ro"
					# "xdg-config/gtk-3.0:ro"
					# "xdg-config/gtk-4.0:ro"
				];
			};
		};
	};

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
			commandLineArgs = "--ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations";
		});
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		dotDir = config.home.homeDirectory;
	};

	programs.yazi = {
		enable = true;
		shellWrapperName = "y";
		plugins = {
			"clipboard" = builtins.fetchGit {
				url = "https://github.com/XYenon/clipboard.yazi.git";
				rev = "0ac03203a88a6ca85539378fbb1b73b75fe8521e";
			};
			# "autosession" = builtins.fetchGit {
			# 	url = "https://github.com/barbanevosa/autosession.yazi.git";
			# 	rev = "7a12b201898a83395dc9981d63a204ac1e103416";
			# };
			# require("autosession"):setup()
		};
		initLua = ''
  	'';
	};

	home.packages = with pkgs; [
		(appimage-run.override { extraPkgs = pkgs: [ pkgs.libepoxy ]; })
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
		vlc
		lazygit
		fish
		grim
		slurp
		satty
		wl-clipboard
		wf-recorder
		btop
		thunar
		dbeaver-bin
		foot
		telegram-desktop
		p7zip
		duf
		dysk
		warp
		nsxiv
		gost
		wtype
		ffmpeg
		hyprpicker
		tesseract
		imagemagick
		zbar
		translate-shell
		gifski
		python3
		python3Packages.pygobject3
		xdg-desktop-portal
		nushell
		sshfs
		rclone
		loupe
		imv
		swayimg
		tldr
    fastfetch
		mycli
		beekeeper-studio
		evtest # Консольная утилита для проверки системных событий ввода (evdev)
    jstest-gtk # Графический интерфейс для калибровки и проверки кнопок геймпада
    input-remapper # Мощный инструмент для переназначения клавиш джойстика под Wayland/Niri
	];
}

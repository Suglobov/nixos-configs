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

	programs.kakoune = {
		enable = true;
	};

	home.packages = with pkgs; [
		(appimage-run.override { extraPkgs = pkgs: [ pkgs.libepoxy ]; })
		# carbonyl # браузер в терминале
		# gnome-logs # Простой и понятный интерфейс от GNOME
		# input-remapper # Мощный инструмент для переназначения клавиш джойстика под Wayland/Niri
		# inputs.noctalia.packages.${pkgs.system}.default
		# jstest-gtk # Графический интерфейс для калибровки и проверки кнопок геймпада
		alacritty # эмулятор терминала
		bat
		beekeeper-studio
		broot
		browsh # браузер в терминале
		btop # диспечер процессов
		clash-verge-rev # vpn
		cliphist # история буфера обмена
		clipse
		dbeaver-bin # подключаться к базам данных
		direnv
		duf	# свободное место на диске
		dust # свободное место на диске
		dysk
		evtest # Консольная утилита для проверки системных событий ввода (evdev)
		eza
		fastfetch
		fd
		ffmpeg
		firefox
		fish # командная оболочка (аля bash)
		flatpak
		foot # эмулятор терминала
		fuzzel
		fzf
		ghostty # эмулятор терминала
		gifski
		gimp
		gnome-text-editor
		gost
		grim
		hyprpicker # заблокированный экран
		imagemagick
		imv
		inputs.fresh.packages.${pkgs.system}.default
		inputs.noctalia-v4.packages.${pkgs.system}.default
		inputs.noctalia-v5.packages.${pkgs.system}.default
		jq
		kdePackages.dolphin # файловый менеджер
		kdePackages.konsole # эмулятор терминала
		lazygit
		linuxConsoleTools
		lnav
		loupe
		lxqt.lxqt-policykit
		micro
		mission-center
		mpvpaper
		mycli
		nautilus
		ncdu # свободное место на диске
		nemo
		nload
		nsxiv
		nushell
		nwg-clipman
		opensnitch-ui
		p7zip
		papirus-icon-theme
		pavucontrol
		playerctl
		python3
		python3Packages.pygobject3
		qt5.qtgraphicaleffects
		qt6.qt5compat
		qt6.qtdeclarative
		qt6.qtwayland
		quickshell
		rclone
		ripgrep
		rofi
		satty
		slurp
		sshfs
		swayimg
		telegram-desktop
		termshark
		tesseract
		thunar # 
		tldr
		tmux
		translate-shell
		tree
		vlc
		warp
		wf-recorder
		wl-clipboard
		wofi
		wtype
		xdg-desktop-portal
		zbar
		zellij
		zoxide
	];
}

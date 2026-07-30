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
			"com.github.tchx84.Flatseal"	#	настройки flatpack
			"io.github.flattool.Warehouse"	#	управление пакетами flatpack
			"ru.linux_gaming.PortProton"	#	запуск игра в linux
			"com.valvesoftware.Steam"	#	игры
			"no.mifi.losslesscut"	#	обрезать видео
			"page.codeberg.JakobDev.jdSystemMonitor"	#	системный монитор
			"org.kde.kruler"	#	экранная линейка
			"org.telegram.desktop"	#	мессенджер
		];
		overrides.settings = {
			global = {
				Environment = {
					XCURSOR_THEME = "Banana";
					XCURSOR_SIZE = "60";
					#	XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons:~/.icons";
				};
				Context.filesystems = [
					"~/.icons:ro"
					#	"/run/current-system/sw/share/icons:ro"
					#	"xdg-config/gtk-3.0:ro"
					#	"xdg-config/gtk-4.0:ro"
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
			#	"autosession" = builtins.fetchGit {
			#		url = "https://github.com/barbanevosa/autosession.yazi.git";
			#		rev = "7a12b201898a83395dc9981d63a204ac1e103416";
			#	};
			#	require("autosession"):setup()
		};
		initLua = ''
		'';
	};

	programs.walker = {	#	запуск программ
		enable = true;
		runAsService = true;
	};

	programs.kakoune = {	#	редактор кода в терминале
		enable = true;
	};
	programs.vicinae = {
		enable = true;
	};

	home.packages = with pkgs; [
		(appimage-run.override { extraPkgs = pkgs: [ pkgs.libepoxy ]; })
		(libinput.override { eventGUISupport = true; })	#	инструмент для работы с устройствами ввода
		#	carbonyl	#	браузер в терминале
		#	gnome-logs	#	Простой и понятный интерфейс от GNOME
		#	input-remapper	#	Мощный инструмент для переназначения клавиш джойстика под Wayland/Niri
		#	inputs.noctalia.packages.${pkgs.system}.default
		#	jstest-gtk	#	Графический интерфейс для калибровки и проверки кнопок геймпада
		#	libinput	#	инструмент для работы с устройствами ввода
		#	nautilus	#	файловый менеджер
		#	nwg-clipman	#	буфер обмена с пред просмотром
		#	telegram-desktop	#	мессенджер
		adwaita-icon-theme
		alacritty	#	эмулятор терминала
		bat
		broot	#	просмотр файлов и папок в виде дерева
		browsh	#	браузер в терминале
		btop	#	диспечер процессов
		clash-verge-rev	#	vpn
		cliphist	#	история буфера обмена
		clipse	#	история буфера обмена
		copyq	#	буфер обмена
		dbeaver-bin	#	подключаться к базам данных
		direnv	#	перменные окружения в директории
		duf	#	свободное место на диске
		dust	#	свободное место на диске
		dysk	#	свободное место на диске
		evtest	#	Консольная утилита для проверки системных событий ввода (evdev)
		eza	#	аналог ls
		fastfetch	#	информация о системе в терминале
		fd	#	аналог find
		ffmpeg
		firefox	#	браузер
		fish	#	командная оболочка (аля bash)
		flatpak
		foot	#	эмулятор терминала
		fuzzel	#	запуск программ
		fzf	#	лейзи поиск
		ghostty	#	эмулятор терминала
		gifski	#	конвертор видео и тд
		gimp
		gnome-text-editor
		gost
		grim
		helix	#	редактор кода в терминале
		hyprpicker	#	заблокированный экран
		imagemagick
		impala # сетевые подключения
		imv
		inputs.fresh.packages.${pkgs.system}.default	#	редактор кода в терминале
		inputs.noctalia-v4.packages.${pkgs.system}.default	#	панельки
		inputs.noctalia-v5.packages.${pkgs.system}.default	#	панельки
		jq
		kdePackages.dolphin	#	файловый менеджер
		kdePackages.konsole	#	эмулятор терминала
		lapce	#	текстовый редактор
		lazygit	#	для работы с git
		linuxConsoleTools
		lnav
		loupe
		lxqt.lxqt-policykit
		micro	#	текстовый редактор из терминала
		mission-center
		mpv	#	видео проигрыватель
		mpvpaper
		mycli	#	командная строка для mysql
		ncdu	#	свободное место на диске
		nemo	#	файловый менеджер
		neovim	#	редактор кода в терминале
		networkmanagerapplet
		nload	#	трафик сети
		nsxiv	#	просмотре картинок
		nushell
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
		rclone	#	монтирование удаленных каталогов в системе
		ripdrag	#	перетаскивание файлов в терминале
		ripgrep	#	поиск в файлах
		rofi	#	запуск программ
		satty
		slurp
		sshfs
		superfile	#	файловый менеджер в терминале
		swayimg
		termshark
		tesseract
		thunar	#	файловый менеджер
		tldr
		tmux	#	консольный мультиплексор терминала
		translate-shell	#	переводчик консольный
		tree
		vicinae	#	запуск программ и многое другое
		vlc	#	видео проигрыватель
		warp
		wf-recorder
		wiremix	#	управление звуком
		wl-clipboard
		wlrctl
		wofi	#	запуск программ
		wtype	#	эмулятор нажатия клавиш
		xcursor-viewer	#	просмотр курсоров
		xdg-desktop-portal
		ydotool	#	эмуляция мышки и клавы
		zbar	#	сканирования и расшифровки штрих-кодов и QR-кодов
		zellij	#	консольный мультиплексор терминала
		zoxide	#	быстрый переход по папкам, в которых был раньше чаще
  	adw-gtk3
  	adwaita-qt
	];
}

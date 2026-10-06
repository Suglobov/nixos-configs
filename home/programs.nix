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
			"app.zen_browser.zen"	#	браузер
			"com.adobe.Flash-Player-Projector"	#	открывать swf файлы
			# "com.github.marhkb.Pods"	#	для docker
			# "com.github.sdv43.whaler"	#	для docker
			# "com.github.taiko2k.tauonmb"	#	аудио плеер
			"com.github.tchx84.Flatseal"	#	настройки flatpack
			# "com.ktechpit.typingmaster"	#	клавиатурный тренажер
			# "com.rcloneui.RcloneUI"	#	для rclone
			# "com.sublimehq.SublimeText"	#	редактор кода
			"com.valvesoftware.Steam"	#	игры
			# "io.github.cmus.cmus"	#	аудио плеер
			"io.github.flattool.Warehouse"	#	управление пакетами flatpack
			"io.github.plrigaux.sysd-manager"	#	systemd manager
			# "no.bragefuglseth.Keypunch"	#	клавиатурный тренажер
			# "no.mifi.losslesscut"	#	обрезать видео
			# "org.clementine_player.Clementine"	#	аудио плеер
			"org.gnome.Logs"	#	journal gui
			# "org.gnome.Lollypop"	#	аудио плеер
			# "org.kde.kruler"	#	экранная линейка
			# "org.kde.ktouch"	#	клавиатурный тренажер
			# "org.pipewire.Helvum"	#	для PipeWire
			# "org.rncbc.qpwgraph"	#	для PipeWire
			"org.telegram.desktop"	#	мессенджер
			# "org.vinegarhq.Sober"	#	roblax
			# "org.xfce.mousepad"	#	текстовый редактор
			# "page.codeberg.JakobDev.jdSystemMonitor"	#	системный монитор
			"rs.ruffle.Ruffle"	#	открывать swf файлы
			"ru.linux_gaming.PortProton"	#	запуск игра в linux
			"space.bigrat.mocktail"	#	roblax
			# "io.github.alamahant.Jasmine"	# запускатель сайтов и сессий
			"im.fluffychat.Fluffychat"	# matrix чат
			"org.mozilla.thunderbird_esr"	# matrix чат
			"io.github.quotient_im.Quaternion"	# matrix чат
			# "com.dec05eba.gpu_screen_recorder"	#	запись видео с экрана
			# "com.github.dail8859.NotepadNext"	#	текстовый редактор
			# "com.obsproject.Studio"	#	запись видео с экрана
			# "io.frama.editide.editide"	#	текстовый редактор
			# "io.github.seadve.Kooha"	#	запись видео с экрана
			# "org.gnome.design.IconLibrary"	#	иконки
			# "org.gnome.gitlab.wwarner.Solitaire"	#	игры
			# "org.kde.dolphin"	#	файловый менеджер (xdg-open не открывает)
			# "org.kde.kate"	#	текстовый редактор
			# "org.kde.kwrite"	#	текстовый редактор
			# "org.notepadng.Notepadng"	#	текстовый редактор
		];
		overrides.settings = {
			global = {
				Environment = {
					XCURSOR_THEME = "Banana";
					XCURSOR_SIZE = "60";
					#	XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons:~/.icons";
					TZ = "Europe/Moscow";
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

	programs.vscode.enable = true;

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
		package = pkgs.yazi.override {
			_7zz = pkgs._7zz-rar; # Включает поддержку RAR внутри Yazi
		};
		# plugins = {
		#		"clipboard" = builtins.fetchGit {
		#			url = "https://github.com/XYenon/clipboard.yazi.git";
		#			rev = "0ac03203a88a6ca85539378fbb1b73b75fe8521e";
		#		};
		# };
		# initLua = ''
		# '';
	};

	programs.walker = {	#	запуск программ
		enable = true;
		runAsService = true;
		config = {
			theme = "my-default";
		};
	};

	programs.kakoune.enable = true;	#	редактор кода в терминале
	# programs.vicinae.enable = true;	#	запуск программ и многое другое

	home.packages = with pkgs; [
		#			hash = "sha256-eFEjCCniMCKeWU0PcZNv+tDYe08SLFPjRplyPY8OFt4=";
		#			owner = "Supreeeme";
		#			repo = "xwayland-satellite";
		#			rev = "v${version}";
		#		#		inherit src;
		#		#		name = "${oldAttrs.pname}-${version}-vendor.tar.gz";
		#		#		outputHash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
		#		# cargoDeps = oldAttrs.cargoDeps.overrideAttrs (pkgs.lib.const {
		#		# });
		#		# Если замена исходников требует обновления зависимостей Cargo (для Rust)
		#		src = pkgs.fetchFromGitHub {
		#		version = "0.8.3";
		#		};
		#	carbonyl	#	браузер в терминале
		#	input-remapper	#	Мощный инструмент для переназначения клавиш джойстика под Wayland/Niri
		#	inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		#	jstest-gtk	#	Графический интерфейс для калибровки и проверки кнопок геймпада
		#	libinput	#	инструмент для работы с устройствами ввода
		#	nautilus	#	файловый менеджер
		#	nwg-clipman	#	буфер обмена с пред просмотром
		#	telegram-desktop	#	мессенджер
		# (xwayland-satellite.overrideAttrs (oldAttrs: rec {
		# alacritty	#	эмулятор терминала
		# anyrun	#	запуск программ
		# candy-icons
		# clash-nyanpasu	#	vpn
		# clashtui	#	vpn
		# clipse	#	история буфера обмена
		# copyq	#	буфер обмена
		# epiphany	# Графический минималистичный браузер
		# flat-remix-icon-theme
		# flclash	#	vpn
		# ghostty	#	эмулятор терминала
		# gpu-screen-recorder	#	запись видео с экрана
		# input-leap	#	совместное использование компа
		# lapce	#	текстовый редактор
		# links2	# Еще один легкий текстовый браузер (с поддержкой графики)
		# mission-center	#
		# mycli	#	командная строка для mysql
		# nchat	#	чат
		# nemo	#	файловый менеджер
		# nushell	#	командная оболочка (аля bash)
		# opensnitch-ui	#
		# papirus-maia-icon-theme
		# qutebrowser	# Браузер с Vim-управлением
		# thunar	#	файловый менеджер
		# translate-shell	#	переводчик консольный
		# w3m	# Консольный текстовый браузер
		# warp	#	передача файлов
		# wayfarer	#	запись видео с экрана
		# wev	# wayland event viewer	события wayland
		# weylus	#	для рисования мышкой
		# wofi	#	запуск программ
		# xwayland-satellite	#	xwayland для wayland без root
		# ydotool	#	эмуляция мышки и клавы
		# }))
		(appimage-run.override { extraPkgs = pkgs: [ pkgs.libepoxy ]; })
		(libinput.override { eventGUISupport = true; })	#	инструмент для работы с устройствами ввода
		_7zz-rar	#	архивато rar
		adw-gtk3	#
		adwaita-icon-theme
		adwaita-qt	#
		bat	#	вывод в консоль содержимое файла (cat)
		beauty-line-icon-theme
		bemenu	#	запуск программ
		bottom	#	диспечер процессов (btm)
		bpftrace	#	высокоуровневый язык и инструмент динамической трассировки для ядра Linux, использующий технологию eBPF
		brightnessctl	#	управление яркостью
		broot	#	файловый менеджер в терминале
		browsh	#	браузер в терминале
		browsr	#	файловый менеджер в терминале
		btop	#	диспечер процессов
		clash-verge-rev	#	vpn
		cliphist	#	история буфера обмена
		# colloid-icon-theme
		ctop	#	для работы с docker
		cmus	#	аудио плеер
		dbeaver-bin	#	подключаться к базам данных
		desktop-file-utils	# помощник для .desktop
		direnv	#	перменные окружения в директории
		duf	#	свободное место на диске
		dust	#	свободное место на диске
		dysk	#	свободное место на диске
		easyeffects	#	аудио настройки
		evtest	#	Консольная утилита для проверки системных событий ввода (evdev)
		eza	#	аналог ls
		fastfetch	#	информация о системе в терминале
		fd	#	аналог find (поиск файлов)
		ffmpeg	#
		firefox	#	браузер
		fish	#	командная оболочка (аля bash)
		foot	#	эмулятор терминала
		fuzzel	#	запуск программ
		fzf	#	лейзи поиск
		gifski	#	конвертор видео и тд
		gimp	#	редактор картинок
		gost	#
		grim	#
		helix	#	редактор кода в терминале
		htop	#	диспечер процессов
		hyprpicker	#	заблокированный экран
		imagemagick	#	редактор картинок
		impala # сетевые подключения
		imv	#	просмотр картинок
		inputs.fresh.packages.${pkgs.stdenv.hostPlatform.system}.default	#	редактор кода в терминале
		inputs.noctalia-v4.packages.${pkgs.stdenv.hostPlatform.system}.default	#	панельки
		inputs.noctalia-v5.packages.${pkgs.stdenv.hostPlatform.system}.default	#	панель
		#inputs.xwayland-satellite.packages.${pkgs.stdenv.hostPlatform.system}.default	# xwayland для wayland без root
		jq	#
		kanagawa-icon-theme
		kdePackages.dolphin	#	файловый менеджер
		kdePackages.kate	#	текстовый редактор
		kdePackages.konsole	#	эмулятор терминала
		kitty	#	эмулятор терминала
    kitty.terminfo	#	для kitty
		lazydocker	#	для работы с docker
		lazygit	#	для работы с git
		lazyjournal	#	для работы journalctl
		libgnomekbd	#	клавиатура
		linuxConsoleTools	#
		lnav	#
		loupe	#
		lxappearance	#	GUI для просмотра тем
		lxqt.lxqt-policykit	#
		micro	#	текстовый редактор из терминала
		mpv	#	видео проигрыватель
		mpvpaper	#
		navi	#	интеративные подсказки для терминала
		ncdu	#	свободное место на диске
		ncpamixer	#	управление звуком в консоли
		neovim	#	редактор кода в терминале
		networkmanagerapplet	#	сетевые настройки
		nload	#	трафик сети
		nsxiv	#	просмотре картинок
		numix-icon-theme-square
		nwg-look	#	GUI для просмотра тем
		onboard	#	клавиатура
		opencode	#	ии
		p7zip	#	архиватор
		pamixer	#	управление звуком в консоли (выводит информацию)
		pantheon.elementary-files	#	файловый менеджер
		papirus-icon-theme
		pavucontrol	#	управление звуком
		perf	# cli для анализа производительности
		playerctl	#	управление плеерами в консоли
		pulsemixer	#	управление звуком в консоли
		pulsemixer	#	управление звуком в консоли
		python3
		python3Packages.pygobject3
		qjournalctl	#	journal gui
		# qogir-icon-theme
		# qt5.qtgraphicaleffects
		# qt6.qt5compat
		# qt6.qtdeclarative
		# qt6.qtwayland
		quickshell	#	создание панелек
		rclone	#	монтирование удаленных каталогов в системе
		ripdrag	#	перетаскивание файлов в терминале
		ripgrep	#	поиск в файлах
		rofi	#	запуск программ
		rose-pine-icon-theme
		satty	#	screenshot annotation tool
		shared-mime-info	#	для mime типов
		slurp	#	выбор области экрана
		squeekboard	#	клавиатура
		sshfs	#	монтирование удаленных каталогов
		superfile	#	файловый менеджер в терминале
		swayimg #	просмотр изображений
		# tela-icon-theme
		television	#	для поиска
		termshark	#	анализатор трафика сети
		tesseract	#	распознавание текста на картинках
		tldr	#	вывод в консоль справки по командам (man)
		tmux	#	консольный мультиплексор терминала
		tree	#	вывод в консоль содержимое папки как дерево
		vlc	#	видео проигрыватель
		wf-recorder	#	запись видео с экрана
		wifitui	#	сетевые настройки
		# winboat	#	windows приложения
		wiremix	#	управление звуком
		wl-clipboard	#	буфер обмена
		wlrctl	#	управление звуком
		wtype	#	эмулятор нажатия клавиш
		wvkbd	#	клавиатура
		xcursor-viewer	#	просмотр курсоров
		xdg-desktop-portal	#	портал для приложений
		xplr	#	файловый менеджер в терминале
		zbar	#	сканирования и расшифровки штрих-кодов и QR-кодов
		zed-editor	#	редактор кода
		zellij	#	консольный мультиплексор терминала
		zoxide	#	быстрый переход по папкам, в которых был раньше чаще
		gcc	#	компилятор для c
	];
}

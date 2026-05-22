# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	time.timeZone = "Europe/Moscow";

	nix.settings = {
		experimental-features = ["nix-command" "flakes" ];
		substituters = [
			"https://cache.nixos.org"
		];
	};

	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true; # Принудительно включает Bluetooth при старте ПК
	};

	fileSystems."/media/eugeny/data" = {
		options = [ "nofail" "x-systemd.device-timeout=5" ];
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d"; # Удаляет сборки старше 7 дней
	};
	# Автоматически находит дубликаты файлов в /nix/store и создает жесткие ссылки, освобождая место
	nix.settings.auto-optimise-store = true; 

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.eugeny = {
		isNormalUser = true;
		description = "eugeny";
		extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" ];
		packages = with pkgs; [];
		shell = pkgs.fish;
	};

	# Select internationalisation properties.
	i18n.defaultLocale = "ru_RU.UTF-8";
	i18n.supportedLocales = [
		"en_US.UTF-8/UTF-8"
		"ru_RU.UTF-8/UTF-8"
	];
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "ru_RU.UTF-8";
		LC_IDENTIFICATION = "ru_RU.UTF-8";
		LC_MEASUREMENT = "ru_RU.UTF-8";
		LC_MONETARY = "ru_RU.UTF-8";
		LC_NAME = "ru_RU.UTF-8";
		LC_NUMERIC = "ru_RU.UTF-8";
		LC_PAPER = "ru_RU.UTF-8";
		LC_TELEPHONE = "ru_RU.UTF-8";
		LC_TIME = "ru_RU.UTF-8";
	};

	xdg.portal = {
			enable = true;
			extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
			config.common.default = [ "gtk" ];
	};


	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	virtualisation.docker.enable = true;

	fonts.packages = with pkgs; [
		# Рекомендуется установить конкретный шрифт, например, JetBrains Mono
		nerd-fonts.jetbrains-mono
		# Или поставьте только символы/иконки (минималистичный вариант)
		# nerd-fonts.symbols-only
	];

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		wget
		git
		curl
		fish
		yazi
		home-manager
		xwayland-satellite
	];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };
	programs.niri.enable = true;
	programs.fish.enable = true;

	#console.luseXkbConfig = true;
	/*services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;*/
	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
				user = "greeter";
			};
		 };
	};
	systemd.services.greetd = {
		serviceConfig = {
			Type = "idle";
			StandardInput = "tty";
			StandardOutput = "tty";
			StandardError = "journal";
			TTYReset = true;
			TTYVHangup = true;
			TTYVTDisallocate = true;
			# ExecStartPost = "${pkgs.kbd}/bin/setleds -D +num";
		};
	};

	# List services that you want to enable:

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "en, ru";
		variant = "";
		options = "grp:caps_toggle";
	};
	services.gnome.gnome-keyring.enable = true;
	services.blueman.enable = true;
	services.flatpak.enable = true;

	services.zapret = {
		enable = true;
		# Включаем поддержку UDP (критично для обхода блокировок QUIC/YouTube)
		udpSupport = true;
		udpPorts = [ "443" ]; # Обрабатывать QUIC трафик на 443 порту
		params = [
			"--dpi-desync=fake,split2"
			"--dpi-desync-ttl=4"
			"--dpi-desync-fooling=md5sig"
			"--dpi-desync-any-protocol"
		];
		# params = [
		# 	"--dpi-desync=fake"
		# 	"--dpi-desync-ttl=1"
		# 	"--dpi-desync-autottl=-2"
		# 	"--dpi-desync-any-protocol" # Рекомендуется оставить для работы других протоколов (не только HTTPS)
		# ];

		# # Параметры для TCP (обычные сайты и базовая десинхронизация)
		# params = [
		# 	"--dpi-desync=fake"
		# 	"--dpi-desync-ttl=3"
		# 	"--dpi-desync-fooling=md5sig"
		# 	"--dpi-desync-any-protocol"
		# ];
		# # # Специальные параметры для UDP, чтобы оживить YouTube без отключения QUIC в браузере
		# udpParams = [
		# 	"--dpi-desync=fake"
		# 	"--dpi-desync-repeats=2"
		# 	"--dpi-desync-any-protocol"
		# ];
	};

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.11"; # Did you read the comment?
}

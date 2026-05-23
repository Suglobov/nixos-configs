# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./modules/locale.nix
		./modules/networking.nix
		./modules/zapret.nix
	];

	nix.settings.experimental-features = ["nix-command" "flakes" ];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true; # Принудительно включает Bluetooth при старте ПК

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

	xdg.portal = {
			enable = true;
			extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
			config.common.default = [ "gtk" ];
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	virtualisation.docker.enable = true;

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	# List packages installed in system profile. To search, run: $ nix search wget
	environment.systemPackages = with pkgs; [
		vim
		wget
		git
		curl
		fish
		yazi
		home-manager
		xwayland-satellite
		amneziawg-tools
		amnezia-vpn
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
	programs.hyprlock.enable = true;

	#console.luseXkbConfig = true;
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

	systemd.services.amnezia-vpn = {
		description = "Amnezia VPN Backend Service";
		after = [ "network.target" ];
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.amnezia-vpn}/bin/AmneziaVPN-service";
			Restart = "always";
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

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.11"; # Did you read the comment?
}

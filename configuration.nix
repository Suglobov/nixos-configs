# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./modules/locale.nix
		./modules/networking.nix
		./modules/displayManager.nix
		./modules/programs.nix
    ./modules/services.nix
		# ./modules/zapret.nix
	];

	nix.settings.experimental-features = ["nix-command" "flakes" ];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	fileSystems."/media/eugeny/data" = {
		options = [ "nofail" "x-systemd.device-timeout=5" ];
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d"; # Удаляет сборки старше 7 дней
	};
	nix.settings.auto-optimise-store = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.eugeny = {
		isNormalUser = true;
		description = "eugeny";
		extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" ];
		packages = with pkgs; [];
		shell = pkgs.fish;
	};

	nixpkgs.config.allowUnfree = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.11"; # Did you read the comment?
}

{ pkgs, ... }:

{
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;
	hardware.steam-hardware.enable = true;
	hardware.graphics.enable = true;
	hardware.uinput.enable = true;

	virtualisation.docker.enable = true;

	services.flatpak.enable = true;
	services.blueman.enable = true;
	services.gnome.gnome-keyring.enable = true;
	services.gvfs.enable = true;
	services.resolved.enable = true;
	services.udev.packages = with pkgs; [
		game-devices-udev-rules # Огромная база правил для DualShock, Xbox, Nintendo и китайских реплик
	];
	services.udev.extraRules = ''
		# Первый геймпад на порту 1-3
		SUBSYSTEM=="input", KERNELS=="1-3:1.0", ATTR{name}="usb gamepad 1"

		# Второй геймпад на порту 1-1
		SUBSYSTEM=="input", KERNELS=="1-1:1.0", ATTR{name}="usb gamepad 2"
	'';

	services.input-remapper = {
		enable = true;
		enableUdevRules = true; # Автоматически дает права на чтение геймпадов
	};

	# Порталы
	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gnome
			xdg-desktop-portal-gtk
		];
		config.common.default = [ "gtk" ];
		config.common."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
		config.common."org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
	};

	# Раскладка клавиатуры
	console.useXkbConfig = true;
	services.xserver.xkb = {
		layout = "us,ru";
		variant = "";
		options = "grp:caps_toggle";
	};

	# Сервис VPN
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

	# Включение NumLock для TTY
	systemd.services.numLockOnTty = {
		wantedBy = [ "multi-user.target" ];
		serviceConfig = { Type = "oneshot"; };
		script = ''
			for tty in /dev/tty{1..6}; do
				${pkgs.kbd}/bin/setleds -D +num < "$tty"
			done
		'';
	};
}

{ pkgs, username, lib, ... }:

{
	hardware.steam-hardware.enable = true;
	hardware.graphics.enable = true;
	hardware.graphics.extraPackages = with pkgs; [
		mesa
		intel-media-driver
		libva
		libva-vdpau-driver
	];
	hardware.uinput.enable = true;
	# hardware.bluetooth.enable = true;
	# hardware.bluetooth.powerOnBoot = true;
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings = {
			General = {
				Experimental = true;		# Открывает видимость BLE клавиатур
				UserspaceHID = true;		# Стабильное автоподключение устройств ввода
			};
		};
	};
	hardware.enableAllFirmware = true;	# Загружает закрытые драйверы для Bluetooth-чипов

	security.polkit.enable = true;


	virtualisation.docker.enable = true;

	services.flatpak.enable = true;
	services.blueman.enable = true;
	services.gnome.gnome-keyring.enable = true;
	services.gvfs.enable = true;
	services.resolved.enable = true;
	services.upower.enable = true;
	services.power-profiles-daemon.enable = true;
	services.udev.packages = with pkgs; [
		game-devices-udev-rules # Огромная база правил для DualShock, Xbox, Nintendo и китайских реплик
	];
	# services.udev.extraRules = ''
	#		# Первый геймпад на порту 1-3
	#		SUBSYSTEM=="input", KERNELS=="1-3:1.0", ATTR{name}="usb gamepad 1"

	#		# Второй геймпад на порту 1-1
	#		SUBSYSTEM=="input", KERNELS=="1-1:1.0", ATTR{name}="usb gamepad 2"
	# '';
	services.dbus.enable = true;
	services.udisks2.enable = true;

	services.kanata = {
		enable = true;
		keyboards.default = {
			configFile = "/home/${username}/.config/kanata/kanata.kbd";
		};
	};
	systemd.services.kanata-default.serviceConfig = {
		ProtectHome = lib.mkForce false;
		DynamicUser = lib.mkForce false;
		User = username;
	};

	# services.input-remapper = {
	#		enable = true;
	#		enableUdevRules = true; # Автоматически дает права на чтение геймпадов
	# };

	# services.netbird.enable = true;	#	создание локальной сети через инернет
	# services.zerotierone = { #	создание локальной сети через инернет
	#		enable = true;
	#		joinNetworks = [ "f3797ba7a8883f76" ]; # ID вашей сети из my.zerotier.com
	# };
	services.tailscale = {
		enable = true;
		# Обязательно для Exit Node / Subnet Router
		useRoutingFeatures = "both";	# или "both", если компьютер сам тоже будет пользоваться exit node
	};
	systemd.services.tailscaled.serviceConfig.Environment = [
		"HTTP_PROXY=http://127.0.0.1:7897"
		"HTTPS_PROXY=http://127.0.0.1:7897"
		# Исключаем локальные сети и сам Tailscale из проксирования
		"NO_PROXY=localhost,127.0.0.1,100.64.0.0/10,192.168.0.0/16"
	];

	xdg.mime.enable = true;
	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal
			xdg-desktop-portal-gtk
			xdg-desktop-portal-wlr
			xdg-desktop-portal-termfilechooser
			# kdePackages.xdg-desktop-portal-kde
			# lxqt.xdg-desktop-portal-lxqt
			# xdg-desktop-portal-gnome
		];
		config.common = {
			default = [ "gtk" ];
			"org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
			"org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
			"org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
		};
	};

	# Раскладка клавиатуры
	console.useXkbConfig = true;
	services.xserver.xkb = {
		layout = "us,ru";
		variant = "";
		options = "grp:caps_toggle";
	};

	# Сервис VPN
	# systemd.services.amnezia-vpn = {
	#		description = "Amnezia VPN Backend Service";
	#		after = [ "network.target" ];
	#		wantedBy = [ "multi-user.target" ];
	#		serviceConfig = {
	#			Type = "simple";
	#			ExecStart = "${pkgs.amnezia-vpn}/bin/AmneziaVPN-service";
	#			Restart = "always";
	#		};
	# };

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

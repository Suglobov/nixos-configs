{ config, lib, pkgs, ... }:

{
	services.kdeconnect = {
		enable = true;
	};

	# Добавляем службу графического пароля для Home Manager
	systemd.user.services.lxqt-policykit = {
		Unit = {
			Description = "PolicyKit Authentication Agent";
			After = [ "graphical-session.target" ];
		};
		Service = {
			ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
			Restart = "on-failure";
		};
		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};

	services.cliphist = {
		enable = true;
		allowImages = true; # Разрешаем cliphist кэшировать картинки
	};

	services.udiskie = {
		enable = true;
		tray = "auto"; # "always" — показывать всегда, "auto" — скрывать, если нет дисков
		notify = true;
		settings = {
			program_options = {
				udisks_version = 2;
				# Если используете зашифрованные LUKS-флешки, раскомментируйте строку ниже:
				# prompt_password = "zenity"; # Нужен пакет pkgs.zenity в системе
			};
		};
	};
}

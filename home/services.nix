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
}

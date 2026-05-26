{ config, pkgs, ... }:

{

	# services.displayManager.sddm = {
	# 	enable = true;
	# 	wayland.enable = true;
	# 	autoNumlock = true; # Включает NumLock на экране входа
	# };

	# services.greetd = {
	# 	enable = true;
	# 	settings = {
	# 		default_session = {
	# 			command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
	# 			user = "greeter";
	# 		};
	# 	 };
	# };
	# systemd.services.greetd = {
	# 	serviceConfig = {
	# 		Type = "idle";
	# 		StandardInput = "tty";
	# 		StandardOutput = "tty";
	# 		StandardError = "journal";
	# 		TTYReset = true;
	# 		TTYVHangup = true;
	# 		TTYVTDisallocate = true;
	# 		# ExecStartPost = "${pkgs.kbd}/bin/setleds -D +num";
	# 	};
	# };
	services.displayManager = {
		sessionPackages = [ pkgs.niri ];
	};

	services.displayManager.ly = {
		enable = true;
		settings = {
			numlock = true;
			animate = true;
			animation = "matrix";
			bigclock = "en";
			save = true; # Сохранять ли имя последнего вошедшего пользователя
		};
	};

}

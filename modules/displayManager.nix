{ config, pkgs, ... }:

{
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
}

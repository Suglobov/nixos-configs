/* для проверки рабочих конфигов
sudo nix-shell -p zapret --run "blockcheck"
*/

{ config, pkgs, ... }:

{
	services.zapret = {
		enable = false;
		udpSupport = true; # Включаем поддержку UDP (критично для обхода блокировок QUIC/YouTube)
		udpPorts = [ "443" ]; # Обрабатывать QUIC трафик на 443 порту

		# params = [
		# 	"--dpi-desync=fake,split2"
		# 	"--dpi-desync-ttl=4"
		# 	"--dpi-desync-fooling=md5sig"
		# ];

		# params = [
		# 	"--dpi-desync=fake"
		# 	"--dpi-desync-ttl=1"
		# 	"--dpi-desync-autottl=-2"
		# ];

		params = [
			"--dpi-desync=fake"
			"--dpi-desync-ttl=3"
			"--dpi-desync-fooling=md5sig"
		];
	};
}

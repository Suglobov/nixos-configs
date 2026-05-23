# sudo nix-shell -p zapret --run blockcheck.sh # для проверки рабочих конфигов

{ config, pkgs, ... }:

{
	services.zapret = {
		enable = true;
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

		# Параметры для TCP (обычные сайты и базовая десинхронизация)
		params = [
			"--dpi-desync=fake"
			"--dpi-desync-ttl=3"
			"--dpi-desync-fooling=md5sig"
		];
		# # Специальные параметры для UDP, чтобы оживить YouTube без отключения QUIC в браузере
		udpParams = [
			"--dpi-desync=fake"
			"--dpi-desync-repeats=2"
		];
	};
}

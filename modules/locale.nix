let
	locale = "ru_RU.UTF-8";
in {
	time.timeZone = "Europe/Moscow";

	i18n.defaultLocale = locale;
	i18n.supportedLocales = [
			"en_US.UTF-8/UTF-8"
			"ru_RU.UTF-8/UTF-8"
	];
	i18n.extraLocaleSettings = {
		LC_ADDRESS = locale;
		LC_IDENTIFICATION = locale;
		LC_MEASUREMENT = locale;
		LC_MONETARY = locale;
		LC_NAME = locale;
		LC_NUMERIC = locale;
		LC_PAPER = locale;
		LC_TELEPHONE = locale;
		LC_TIME = locale;
	};
}

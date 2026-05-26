{ ... }:

{
	services.flatpak = {
		enable = true;
		uninstallUnmanaged = false;
		remotes = [{
			name = "flathub";
			location = "https://flathub.org/repo/flathub.flatpakrepo";
		}];
		packages = [
			"com.github.tchx84.Flatseal"
			"ru.linux_gaming.PortProton"
			"io.github.flattool.Warehouse"
		];
	};

	services.kdeconnect = {
		enable = true;
	};
}

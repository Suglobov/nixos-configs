{ config, pkgs, inputs, ... }:

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
			"com.obsproject.Studio"
		];
	};

	programs.chromium = {
		enable = true;
		package = (config.lib.nixGL.wrap pkgs.google-chrome);
		commandLineArgs = [
			"--ozone-platform-hint=wayland"
			"--enable-features=WaylandWindowDecorations"
		];
	};

	programs.vscode = {
		enable = true;
		package = (pkgs.vscode.override {
			commandLineArgs = "--ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations";
		});
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		dotDir = config.home.homeDirectory;
	};

	home.packages = with pkgs; [
		(appimage-run.override { extraPkgs = pkgs: [ pkgs.libepoxy ]; })
		inputs.noctalia.packages.${pkgs.system}.default
		inputs.fresh.packages.${pkgs.system}.default
		kdePackages.dolphin
		kdePackages.konsole
		flatpak
		fuzzel
		fzf
		ripgrep
		fd
		zoxide
		bat
		eza
		direnv
		jq
		vlc
		lazygit
		fish
		grim
		slurp
		satty
		wl-clipboard
		wf-recorder
		btop
		thunar
		dbeaver-bin
		foot
		telegram-desktop
		p7zip
		duf
		dysk
		warp
		nsxiv
		gost
		wtype
		ffmpeg
		hyprpicker
		tesseract
		imagemagick
		zbar
		translate-shell
		gifski
		python3
		python3Packages.pygobject3
		xdg-desktop-portal
	];
}

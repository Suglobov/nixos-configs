{ config, lib, ... }:
{
	home.activation.makeSymlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] (
		let
			homeDir = config.home.homeDirectory;
			targetDir = "/mnt/data";
			symlinks = [{
					link = "${homeDir}/.var/app/ru.linux_gaming.PortProton/data/prefixes";
					target = "${targetDir}/PortProton/prefixes";
				} {
					link = "${homeDir}/.config/niri";
					target = "${targetDir}/nixos/.config/niri";
				} {
					link = "${homeDir}/.config/noctalia-v4";
					target = "${targetDir}/nixos/.config/noctalia-v4";
				} {
					link = "${homeDir}/.config/noctalia";
					target = "${targetDir}/nixos/.config/noctalia";
				} {
					link = "${homeDir}/.config/fish";
					target = "${targetDir}/nixos/.config/fish";
				} {
					link = "${homeDir}/.config/yazi";
					target = "${targetDir}/nixos/.config/yazi";
				} {
					link = "${homeDir}/.config/fuzzel";
					target = "${targetDir}/nixos/.config/fuzzel";
				} {
					link = "${homeDir}/.config/hypr";
					target = "${targetDir}/nixos/.config/hypr";
				} {
					link = "${homeDir}/.config/quickshell";
					target = "${targetDir}/nixos/.config/quickshell";
				} {
					link = "${homeDir}/.config/walker";
					target = "${targetDir}/nixos/.config/walker";
				} {
					link = "${homeDir}/.config/mimeapps.list";
					target = "${targetDir}/nixos/.config/mimeapps.list";
				} {
					link = "${homeDir}/.config/kanata";
					target = "${targetDir}/nixos/.config/kanata";
				} {
					link = "${homeDir}/.config/anyrun";
					target = "${targetDir}/nixos/.config/anyrun";
				} {
					link = "${homeDir}/.config/xkb";
					target = "${targetDir}/nixos/.config/xkb";
				} {
					link = "${homeDir}/.config/kitty";
					target = "${targetDir}/nixos/.config/kitty";
				} {
					link = "${homeDir}/.config/television";
					target = "${targetDir}/nixos/.config/television";
				}	{
					link = "${homeDir}/.config/xdg-desktop-portal";
					target = "${targetDir}/nixos/.config/xdg-desktop-portal";
				}	{
					link = "${homeDir}/.config/xdg-desktop-portal-termfilechooser";
					target = "${targetDir}/nixos/.config/xdg-desktop-portal-termfilechooser";
				}	{
					link = "${homeDir}/.config/nvim";
					target = "${targetDir}/nixos/.config/nvim";
				}

			];
		in
			lib.concatMapStringsSep "\n" (item: ''
				linkPath="${item.link}"
				targetPath="${item.target}"
				if [ -f "$targetPath" ]; then
					mkdir -p "$(dirname "$targetPath")"
				else
					mkdir -p "$targetPath"
				fi
				if [ -e "$linkPath" ] && [ ! -L "$linkPath" ]; then
					rm -rf "$linkPath"
				fi
				ln -sfn "$targetPath" "$linkPath"
			'') symlinks
	);
}

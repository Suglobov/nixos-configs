{ config, lib, ... }:
{
	home.activation.makeSymlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] (
		let
			homeDir = config.home.homeDirectory;
			symlinks = [{
					link = "${homeDir}/.var/app/ru.linux_gaming.PortProton/data/prefixes";
					target = "${homeDir}/data/PortProton/prefixes";
				} {
					link = "${homeDir}/.config/niri";
					target = "${homeDir}/nixos/.config/niri";
				} {
					link = "${homeDir}/.config/noctalia";
					target = "${homeDir}/nixos/.config/noctalia";
				} {
					link = "${homeDir}/.config/fish";
					target = "${homeDir}/nixos/.config/fish";
				} {
					link = "${homeDir}/.config/yazi";
					target = "${homeDir}/nixos/.config/yazi";
				} {
					link = "${homeDir}/.config/fuzzel";
					target = "${homeDir}/nixos/.config/fuzzel";
				} {
					link = "${homeDir}/.config/hypr";
					target = "${homeDir}/nixos/.config/hypr";
				}
			];
		in
			lib.concatMapStringsSep "\n" (item: ''
				linkPath="${item.link}"
				targetPath="${item.target}"
				mkdir -p "$targetPath"
				if [ -e "$linkPath" ] && [ ! -L "$linkPath" ]; then
					rm -rf "$linkPath"
				fi
				ln -sfn "$targetPath" "$linkPath"
			'') symlinks
	);
}

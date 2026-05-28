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

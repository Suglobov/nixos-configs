{
	description = "Config NixOS";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nix-flatpak.url = "github:gmodena/nix-flatpak";
		noctalia-v5.url = "github:noctalia-dev/noctalia/main";
		noctalia-v4.url = "github:noctalia-dev/noctalia/legacy-v4";
		noctalia = {
			url = "github:noctalia-dev/noctalia-shell/main";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		fresh.url = "github:sinelaw/fresh";

		elephant.url = "github:abenz1267/elephant/23f37238367355cf46843015ad5e94706200176a";
		walker.url = "github:abenz1267/walker/42b3ed88abf50bc52638fb2835b7f17e3ea3ac4c";
		walker.inputs.elephant.follows = "elephant";
		niri.url = "git+file:///mnt/data/programs/niri";
	};

	outputs = {
		self,
		nixpkgs,
		noctalia,
		noctalia-v4,
		noctalia-v5,
		home-manager,
		nix-flatpak,
		fresh,
		...
	}@inputs:
	let
		username = "eugeny"; 
	in {
		nixosConfigurations = {
			nixos = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs username; }; 

				modules = [
					./hardware-configuration.nix
					./configuration.nix
					{
						nixpkgs.hostPlatform = "x86_64-linux";
						nixpkgs.overlays = [
							(final: prev: {
								niri = inputs.niri.packages.${final.system}.default;
							})
						];
					}
					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.backupFileExtension = "bak";
						home-manager.extraSpecialArgs = { inherit inputs username; };

						home-manager.users.${username} = {
							imports = [
								./home.nix
								nix-flatpak.homeManagerModules.nix-flatpak
								inputs.walker.homeManagerModules.default
							];
						};
					}
				];
			};
		};
	};
}

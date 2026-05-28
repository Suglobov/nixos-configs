{
	description = "Config NixOS";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nix-flatpak.url = "github:gmodena/nix-flatpak";
		noctalia = {
			url = "github:noctalia-dev/noctalia-shell/main";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		fresh.url = "github:sinelaw/fresh";
	};

	outputs = { self, nixpkgs, noctalia, home-manager, nix-flatpak, fresh, ... }@inputs: 
	let
		# ГЛАВНАЯ ПЕРЕМЕННАЯ: Меняете имя здесь — оно меняется вообще везде
		username = "eugeny"; 
	in {
		nixosConfigurations = {
			nixos = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				
				# Прокидываем переменную username внутрь configuration.nix
				specialArgs = { inherit inputs username; }; 

				modules = [
					./hardware-configuration.nix
					./configuration.nix
					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = { inherit inputs username; };
						
						# Динамически подставляем имя пользователя в Home Manager
						home-manager.users.${username} = {
							imports = [ 
								./home.nix 
								nix-flatpak.homeManagerModules.nix-flatpak 
							];
						};
					}
				];
			};
		};
	};
}

{
  lib,
  cairo,
  dbus,
  libGL,
  libdisplay-info_0_3,
  libinput,
  seatd,
  libxkbcommon,
  libgbm,
  pango,
  pipewire,
  pkg-config,
  rustPlatform,
  systemd,
  wayland,
  installShellFiles,
  niriSrc,
}:

let
  revision = lib.trim (lib.replaceStrings [ "\n" ] [ "" ] (
    builtins.readFile (niriSrc + "/.git/refs/heads/master")
  ));
in

rustPlatform.buildRustPackage {
  pname = "niri";
  version = revision;

  src = niriSrc;

  postPatch = ''
    patchShebangs resources/niri-session
    substituteInPlace resources/niri.service \
      --replace-fail 'ExecStart=niri' "ExecStart=$out/bin/niri"
  '';

  cargoLock = {
    lockFile = "${niriSrc}/Cargo.lock";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      cairo
      dbus
      libGL
      libdisplay-info_0_3
      libinput
      seatd
      libxkbcommon
      libgbm
      pango
      wayland
    ]
    ++ lib.optional true "dbus" # dbus always needed
    ++ lib.optional true pipewire # screencast
    ++ lib.optional true systemd; # systemd

  buildFeatures = [
    "dbus"
    "xdp-gnome-screencast"
    "systemd"
  ];
  buildNoDefaultFeatures = true;

  preCheck = ''
    export XDG_RUNTIME_DIR="$(mktemp -d)"
  '';

  checkFlags = [
    "--skip=::egl"
  ];

  postInstall =
    ''
      installShellCompletion --cmd niri \
        --bash <($out/bin/niri completions bash) \
        --fish <($out/bin/niri completions fish) \
        --zsh <($out/bin/niri completions zsh)

      install -Dm644 resources/niri.desktop -t $out/share/wayland-sessions
      install -Dm644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
      install -Dm755 resources/niri-session $out/bin/niri-session
      install -Dm644 resources/niri{.service,-shutdown.target} -t $out/lib/systemd/user
    '';

  env = {
    RUSTFLAGS = toString (
      map (arg: "-C link-arg=" + arg) [
        "-Wl,--push-state,--no-as-needed"
        "-lEGL"
        "-lwayland-client"
        "-Wl,--pop-state"
      ]
    );
  };
}

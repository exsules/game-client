{
  pkgs,
  config,
  ...
}: {
  env = {
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    LD_LIBRARY_PATH = "${pkgs.libxkbcommon}/lib";
  };

  languages.rust = {
    enable = true;
    channel = "nightly";
    components = ["rustc" "cargo" "clippy" "rustfmt" "rust-analyzer"];
  };

  languages.nix.enable = true;
  git-hooks = {
    hooks = {
      cargo-check.enable = true;
      clippy = {
        enable = true;
        settings.denyWarnings = true;
      };
      rustfmt.enable = true;
      rustfmt.packageOverrides.rustfmt = config.languages.rust.toolchain.rustfmt;
    };
    settings.rust.cargoManifestPath = "./Cargo.toml";
  };
  dotenv.enable = true;

  packages = with pkgs; [
    alejandra
    alsa-lib
    cargo-deny
    cargo-machete
    libudev-zero
    libxkbcommon
    pkg-config
    udev
    vulkan-loader
    vulkan-tools
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  scripts.cargofmt.exec = ''
    cargo fmt --all -- --check
  '';

  scripts.clippy.exec = ''
    cargo clippy --workspace --tests --bins --lib -- -D warnings
  '';

  enterShell = ''
    echo -e "
      Exsules Game Client
    "
    echo "Rust version: $(rustc --version)"
    echo "Cargo version: $(cargo --version)"
  '';

  enterTest = ''
  '';
}

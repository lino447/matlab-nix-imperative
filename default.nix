{ pkgs ? import <nixpkgs> {} }:

let
  targetPkgs = pkgs: with pkgs; [
    gtk3
    atk
    cairo
    cups
    dbus
    fontconfig
    gdk-pixbuf
    nspr
    nss
    pango
    alsa-lib
    libselinux
    glib
    libGL
    jre
    mesa_glu
    ncurses
    pam
    zlib
    libxcrypt-legacy
    xkeyboard_config
    udev
    # For MATLAB R2021a
    freetype
    # For MATLAB R2023a
    gtk2
    libdrm
    mesa
    libuuid
  ]
  ++
  (with xorg; [
    libX11
    libXft
    libXext
    libXi
    libXmu
    libXp
    libXpm
    libXrandr
    libXrender
    libXt
    libXtst
    libXxf86vm
    libxcb
    libXcomposite
    libXcursor
    libXdamage
    libXfixes
    libXinerama
    libXScrnSaver
  ]);
in {
  matlab = runScript: (pkgs.buildFHSUserEnv {
    name = "matlab";
    inherit targetPkgs;
    inherit runScript;
  }).env;

  # shell where matlab can be run, e.g. for installation etc.
  matlab-shell = (pkgs.buildFHSUserEnv {
    name = "matlab-shell";
    targetPkgs = pkgs: with pkgs; targetPkgs pkgs ++ [ unzip zsh ];
    runScript = "zsh";
  }).env;
}

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.gcc
    pkgs.cmake
    pkgs.ninja
    pkgs.wxc
    pkgs.wxwidgets_3_3
  ];
}

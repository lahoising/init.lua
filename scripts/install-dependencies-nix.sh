#!/usr/bin/env bash

NIXPKGS_PREFIX='nixpkgs'
nix-env -iA \
  $NIXPKGS_PREFIX.cargo \
  $NIXPKGS_PREFIX.cmake \
  $NIXPKGS_PREFIX.curl \
  $NIXPKGS_PREFIX.gnat \
  $NIXPKGS_PREFIX.gnumake \
  $NIXPKGS_PREFIX.gnutar \
  $NIXPKGS_PREFIX.gzip \
  $NIXPKGS_PREFIX.jdk \
  $NIXPKGS_PREFIX.lua \
  $NIXPKGS_PREFIX.luajitPackages.luarocks \
  $NIXPKGS_PREFIX.readline \
  $NIXPKGS_PREFIX.ripgrep \
  $NIXPKGS_PREFIX.rustc \
  $NIXPKGS_PREFIX.unzip \
  $NIXPKGS_PREFIX.wget \


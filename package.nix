{
  isMinimal ? false,
  isWsl ? false,
}: {lib, ...}: {
  imports =
    [
      ./core
      ./utils
    ]
    ++ lib.optional (!isMinimal) ./extra;

  nixpkgs.overlays = [
    (
      final: prev: {
        imSelect =
          if final.stdenv.isDarwin
          then {
            command = final.fetchurl {
              url = "https://github.com/Fr4nk1inCs/macism/releases/download/v1.3.3/macism";
              sha256 = "sha256-wn7Wlh291PpbSrQLWC/fU654suoPHK4/4O7zQ5Z3ldE=";
              executable = true;
            };
            mode = "com.apple.keylayout.ABC";
          }
          else if isWsl
          then {
            command = final.fetchurl {
              url = "https://raw.githubusercontent.com/daipeihust/im-select/master/win-mspy/out/x64/im-select-mspy.exe";
              sha256 = "sha256-FBRkrJXVemB6EY2PBt8UbrLsaENP4xQGPMzl8UKPrpo=";
              executable = true;
            };
            mode = "英语模式";
          }
          else {
            command = "fcitx5-remote";
            mode = "keyboard-us";
          };
        neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
          patches =
            old.patches
            ++ [
              # Fix byte index encoding bounds.
              # - https://github.com/neovim/neovim/pull/30747
              # - https://github.com/nix-community/nixvim/issues/2390
              (final.fetchpatch {
                name = "fix-lsp-str_byteindex_enc-bounds-checking-30747.patch";
                url = "https://patch-diff.githubusercontent.com/raw/neovim/neovim/pull/30747.patch";
                hash = "sha256-2oNHUQozXKrHvKxt7R07T9YRIIx8W3gt8cVHLm2gYhg=";
              })
            ];
        });
      }
    )
  ];
}

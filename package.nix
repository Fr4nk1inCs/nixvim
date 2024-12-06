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
        inherit isWsl;
        maple-mono = prev.callPackage (
          {
            stdenvNoCC,
            fetchzip,
          }:
            stdenvNoCC.mkDerivation {
              name = "maple-mono-NF-CN";
              dontConfigue = true;
              src = fetchzip {
                url = "https://github.com/subframe7536/maple-font/releases/download/v7.0-beta29/MapleMono-NF-CN.zip";
                sha256 = "sha256-ybCeft2/i7UY3C/Pew76RiwVEM+vzUtDQuvr4dAkaUY=";
                stripRoot = false;
              };

              installPhase = ''
                mkdir -p $out/share/fonts
                cp -R $src $out/share/fonts/truetype/
              '';

              meta = {
                description = "Maple Mono NF CN";
                homepage = "https://github.com/subframe7536/maple-font";
              };
            }
        ) {};
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

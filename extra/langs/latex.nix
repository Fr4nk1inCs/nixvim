{pkgs, ...}: let
  forwardSearchAfter = pkgs.stdenv.isDarwin || !pkgs.isWsl; # Avoid focus being taken by the PDF viewer
  forwardSearch =
    if pkgs.stdenv.isDarwin
    then {
      executable = "${pkgs.skimpdf}/Applications/Skim.app/Contents/SharedSupport/displayline";
      args = [
        "-g"
        "-r"
        "%l"
        "%p"
        "%f"
      ];
    }
    else if pkgs.isWsl
    then {
      executable = "/mnt/c/Users/fushen/AppData/Local/SumatraPDF/SumatraPDF.exe";
      args = [
        "-reuse-instance"
        "%p"
        "-forward-search"
        "%f"
        "%l"
      ];
    }
    else {
      executable = "zathura";
      args = [
        "--synctex-forward"
        "%l:1:%f"
        "%p"
      ];
    };
in {
  plugins.lsp.servers.texlab = {
    enable = true;
    settings.texlab = {
      build = {
        executable = "xelatex";
        args = [
          "-shell-escape"
          "-synctex=1"
          "-interaction=nonstopmode"
          "%f"
        ];
        onSave = true;
        inherit forwardSearchAfter;
      };
      inherit forwardSearch;
      chktex = {
        onOpenAndSave = true;
        onEdit = true;
      };
    };
  };
}

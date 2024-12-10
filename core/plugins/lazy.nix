{pkgs, ...}: {
  # FIXME: This plugin is not yet supported by nixvim
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "lzn-auto-require";
      src = pkgs.fetchFromGitHub {
        owner = "horriblename";
        repo = "lzn-auto-require";
        rev = "ef746afb55467984ef3200d9709c8059ee0257d0";
        hash = "sha256-KC1z+zC9vKODllZVpBu+udzM12oYJaS8e6LdXWtQ89U=";
      };
    })
  ];
  plugins.lz-n.enable = true;

  extraConfigLuaPost = ''
    require('lzn-auto-require').enable()
  '';
}

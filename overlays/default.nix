inputs:
let

  # inherits

  inherit (builtins)
    attrValues
    ;

  inherit (inputs.nixpkgs)
    lib
    ;

  inherit (lib.attrsets)
    genAttrs
    ;

  inherit (lib.fixedPoints)
    composeManyExtensions
    ;

  inherit (inputs.self.library)
    getDirectories
    ;

  # overlays

  allLocalOverlays = genAttrs (getDirectories ../overlays) (
    dir: final: prev: {
      "${dir}" = final.callPackage ../overlays/${dir}/overlay.nix { };
    }
  );

  allLocalPackages = genAttrs (getDirectories ../packages) (
    dir: final: prev: {
      "${dir}" = final.callPackage ../packages/${dir}/package.nix { };
    }
  );

  default = composeManyExtensions ((attrValues allLocalOverlays) ++ (attrValues allLocalPackages));

in
allLocalOverlays // allLocalPackages // { inherit default; }

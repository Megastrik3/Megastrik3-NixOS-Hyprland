# ./overlays/default.nix

final: prev: {
  # This overlay extends the set of Python packages.
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      # Workaround for nixpkgs issue #437058 by disabling failing tests.
      i3ipc = python-prev.i3ipc.overridePythonAttrs (oldAttrs: {
        doCheck = false; # Disables the check phase entirely
      });
    })
  ];
}
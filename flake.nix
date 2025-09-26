{
  description = "Claude Code Mate - A companion tool for Claude Code, enabling flexible LLM integration through LiteLLM proxy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Python with required dependencies
        python = pkgs.python312;
        pythonEnv = python.withPackages (ps: with ps; [
          # Core dependencies
          pyyaml
          psutil
          jinja2

          # UI dependencies (equivalent to pgserver and prisma)
          # Note: pgserver and prisma may need to be installed via pip in the dev shell

          # Build dependencies
          setuptools
          wheel
          pip
        ]);

        # The main package
        claude-code-mate = pkgs.python312Packages.buildPythonPackage rec {
          pname = "claude-code-mate";
          version = "0.2.0";

          src = ./.;

          format = "pyproject";

          nativeBuildInputs = with pkgs.python312Packages; [
            hatchling
            pip
          ] ++ (with pkgs; [ makeWrapper ]);

          propagatedBuildInputs = with pkgs.python312Packages; [
            pyyaml
            psutil
            jinja2
          ];

          # Install litellm separately since it's not in nixpkgs
          postInstall = ''
            $out/bin/pip install litellm[proxy]>=1.77.1
          '';

          # Create wrapper scripts
          postFixup = ''
            makeWrapper ${pythonEnv}/bin/python $out/bin/ccm \
              --add-flags "$out/lib/python3.12/site-packages/main.py"
            makeWrapper ${pythonEnv}/bin/python $out/bin/claude-code-mate \
              --add-flags "$out/lib/python3.12/site-packages/main.py"
          '';

          meta = with pkgs.lib; {
            description = "A companion tool for Claude Code, enabling flexible LLM integration through LiteLLM proxy";
            homepage = "https://github.com/RussellLuo/claude-code-mate";
            license = licenses.mit;
            maintainers = [];
            platforms = platforms.unix;
          };
        };

      in
      {
        # Default package
        packages.default = claude-code-mate;
        packages.claude-code-mate = claude-code-mate;

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pythonEnv
            # Additional development tools
            git
          ];

          shellHook = ''
            echo "Claude Code Mate development environment"
            echo "Python version: $(python --version)"
            echo ""
            echo "Available commands:"
            echo "  python main.py --help"
            echo ""
            echo "To install additional dependencies:"
            echo "  pip install litellm[proxy]>=1.77.1"
            echo "  pip install pgserver>=0.1.4 prisma>=0.15.0  # for UI support"
          '';
        };

        # Application that can be run with 'nix run'
        apps.default = {
          type = "app";
          program = "${claude-code-mate}/bin/ccm";
        };

        apps.ccm = {
          type = "app";
          program = "${claude-code-mate}/bin/ccm";
        };
      });
}
{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-vscode.hexeditor
        tamasfe.even-better-toml
        elixir-lsp.vscode-elixir-ls
        arrterian.nix-env-selector
        denoland.vscode-deno
        esbenp.prettier-vscode
        llvm-vs-code-extensions.vscode-clangd
        vscode-extensions.ms-dotnettools.csharp
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "starfall-visual-studio-code";
          publisher = "sndst00m";
          version = "0.5.4";
          sha256 = "sha256-f1pnuqz8aC3FKUI/GnNor+uY94+1UlYOyW1OvuuMqK8=";
        }
        {
          name = "flutter";
          publisher = "Dart-Code";
          version = "3.73.20230904";
          sha256 = "sha256-2kT5hfCupM1njC07Du9bcavxp2kDIJNIMsMYd7Omr44=";
        }
        {
          name = "dart-code";
          publisher = "Dart-Code";
          version = "3.73.20230927";
          sha256 = "sha256-B6CD+2OgKrIHG87FtKbuqdpn3levm9RO6GFjmnW24z4=";
        }
        {
          name = "direnv";
          publisher = "mkhl";
          version = "0.15.2";
          sha256 = "sha256-Da9Anme6eoKLlkdYaeLFDXx0aQgrtepuUnw2jEPXCVU=";
        }
        {
          name = "Go";
          publisher = "golang";
          version = "0.39.1";
          sha256 = "sha256-xOiMVUkcgwkMjYfNzFB3Qhfg26jf5nssaTfw0U+sAX0=";
        }
        {
          name = "rust-analyzer";
          publisher = "rust-lang";
          version = "0.4.1679";
          sha256 = "sha256-AlYyJ5QOx31O+geR+hAodx6pXQFJSH2tWuK+5rD7xOw=";
        }
        {
          name = "svelte-vscode";
          publisher = "svelte";
          version = "107.11.0";
          sha256 = "sha256-vz4yO1VhTdpdfXw6daD1TinSTFlmQyYEDrxVklMX8Rk=";
        }
        {
          name = "ruby-lsp";
          publisher = "Shopify";
          version = "0.4.8";
          sha256 = "sha256-hfv9ndpQs7hFJixsqp9naWIQNPxmGPQG6MxC4wlPqcA=";
        }
        {
          name = "wgsl";
          publisher = "PolyMeilex";
          version = "0.1.16";
          sha256 = "sha256-0EcV80N8u3eQB74TNedjM5xbQFY7avUu3A8HWi7eZLk=";
        }
        {
          name = "autodocstring";
          publisher = "njpwerner";
          version = "0.6.1";
          sha256 = "sha256-NI0cbjsZPW8n6qRTRKoqznSDhLZRUguP7Sa/d0feeoc=";
        }
      ];
    })
  ];
}

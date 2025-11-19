{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.debugpy
        ms-vscode.hexeditor
        ms-dotnettools.csharp
        vadimcn.vscode-lldb
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
      ] ++ (with pkgs.vscode-marketplace; [
        bbenoist.nix
        tamasfe.even-better-toml
        jakebecker.elixir-ls
        arrterian.nix-env-selector
        denoland.vscode-deno
        esbenp.prettier-vscode
        llvm-vs-code-extensions.vscode-clangd
        dart-code.dart-code
        dart-code.flutter
        golang.go
        rust-lang.rust-analyzer
        svelte.svelte-vscode
        mkhl.direnv
        njpwerner.autodocstring
        shopify.ruby-lsp
        polymeilex.wgsl
        tauri-apps.tauri-vscode
        ziglang.vscode-zig
        redhat.java
        vue.volar
        editorconfig.editorconfig
        arcanis.vscode-zipfs
        jakebecker.elixir-ls
        phoenixframework.phoenix
        bradlc.vscode-tailwindcss
        myriad-dreamin.tinymist
        haskell.haskell
        justusadam.language-haskell
        kdl-org.kdl
        savonet.vscode-liquidsoap
        denoland.vscode-deno
        prisma.prisma
      ]);
    })
  ];
}

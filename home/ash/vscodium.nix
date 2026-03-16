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
        jnoortheen.nix-ide
        mkhl.direnv

        jakebecker.elixir-ls
        phoenixframework.phoenix

        dart-code.dart-code
        dart-code.flutter

        tamasfe.even-better-toml

        denoland.vscode-deno
        esbenp.prettier-vscode
        llvm-vs-code-extensions.vscode-clangd
        golang.go
        rust-lang.rust-analyzer
        svelte.svelte-vscode
        njpwerner.autodocstring
        shopify.ruby-lsp
        wgsl-analyzer.wgsl-analyzer
        tauri-apps.tauri-vscode
        ziglang.vscode-zig
        redhat.java
        vue.volar
        editorconfig.editorconfig
        arcanis.vscode-zipfs
        jakebecker.elixir-ls
        bradlc.vscode-tailwindcss
        myriad-dreamin.tinymist
        haskell.haskell
        justusadam.language-haskell
        kdl-org.kdl
        savonet.vscode-liquidsoap
        denoland.vscode-deno
        prisma.prisma
        pixl-garden.bongocat
      ]) ++ (with pkgs.open-vsx; [
        jeanp413.open-remote-ssh
      ]);
    })
  ];
}

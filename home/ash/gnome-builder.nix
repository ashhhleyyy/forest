{ pkgs, ... }: {
  home.packages = with pkgs; [
    (gnome-builder.overrideAttrs (finalAttrs: previousAttrs: {
      preFixup = previousAttrs.preFixup + ''
      gappsWrapperArgs+=(
        --prefix PATH : "${glib}/bin"
      )
      '';
    }))
    flatpak-builder
  ];
}

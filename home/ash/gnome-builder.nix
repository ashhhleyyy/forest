{ pkgs, ... }: {
  home.packages = with pkgs; [
    #(gnome-builder.overrideAttrs (finalAttrs: previousAttrs: {
    #  preFixup = previousAttrs.preFixup + ''
    #  gappsWrapperArgs+=(
    #    --prefix PATH : "${glib}/bin"
    #  )
    #  '';
    #}))
    gnome-builder
    flatpak-builder
  ];
}

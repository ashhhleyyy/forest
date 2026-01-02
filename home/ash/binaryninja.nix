{ config, pkgs, ... }:
let
  binaryninja = pkgs.binaryninja-free.overrideAttrs {
    pname = "binaryninja";
    version = "5.2.8722";
    src = pkgs.requireFile {
      name = "binaryninja_linux_stable_personal.zip";
      url = "https://portal.binary.ninja/";
      hash = "sha256-NSfNlaUD0bYfC8AcWAGQw4fsUFCdsEIqwOYxFDLmR8g=";
    };
    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "com.vector35.binaryninja";
        desktopName = "Binary Ninja";
        comment = "A Reverse Engineering Platform";
        exec = "binaryninja";
        icon = "binaryninja";
        mimeTypes = [
          "application/x-binaryninja"
          "x-scheme-handler/binaryninja"
        ];
        categories = [ "Utility" ];
      })
    ];
    autoPatchelfIgnoreMissingDeps = [
      "libQt6QuickVectorImageGenerator.so.6"
      "libQt6Quick.so.6"
      "libQt6Qml.so.6"
      "libQt6PrintSupport.so.6"
      "libQt6Qml.so.6"
      "libQt6ShaderTools.so.6"
    ];
  };
in
{
  home.packages = [
    binaryninja
  ];
}

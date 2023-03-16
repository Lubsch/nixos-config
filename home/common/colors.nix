{ lib, ... }: {
  options = {
    colors = lib.genAttrs
      [ "alpha" "background" "foreground" "base00" "base01" "base02" "base03" "base04" "base05" "base06" "base08" "base07" "base09" "base10" "base11" "base12" "base13" "base14" "base15" ]
      (_: lib.mkOption { type = lib.types.str; });
  };

  config = {
    colors = {
      alpha = "E5";

      # Gruvbox
      background = "282828";
      foreground = "ebdbb2";
      base00 =  "282828";
      base01 =  "cc241d";
      base02 =  "98971a";
      base03 =  "d79921";
      base04 =  "458588";
      base05 =  "b16286";
      base06 =  "689d6a";
      base08 =  "928374";
      base07 =  "a89984";
      base09 =  "fb4934";
      base10 = "b8bb26";
      base11 = "fabd2f";
      base12 = "83a598";
      base13 = "d3869b";
      base14 = "8ec07c";
      base15 = "ebdbb2";
    };
  };
}


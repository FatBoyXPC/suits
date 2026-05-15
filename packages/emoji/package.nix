{
  pkgs,
  self',
}:

let
  clipit = self'.packages.clipit;
  emoji-picker = pkgs.writeShellApplication {
    name = "emoji-picker";

    runtimeInputs = with pkgs; [
      clipit
      fzf
    ];

    text = ''
      selected_emoji=$(fzf -m < ${./emojis} | sed "s/.*  \([^ ].*\)/\1/" | tr -d "\n")

      if [ -z "$selected_emoji" ]; then
          exit 1
      fi

      printf "%s" "$selected_emoji" | clipit
    '';
  };
in
pkgs.writeShellApplication {
  name = "emoji";

  runtimeInputs = with pkgs; [
    clipit
    fzf
    kitty
    xdotool
  ];

  text = ''
    function main() {
        if ! kitty --class kittypicker ${emoji-picker}/bin/emoji-picker; then
            return 0
        fi

        sleep 0.1
        xdotool key --clearmodifiers ctrl+shift+v
    }

    main
  '';
}

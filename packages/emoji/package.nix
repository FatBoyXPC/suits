{
  self',
  writeShellApplication,
  fzf,
  kitty,
  xdotool,
}:

let
  clipit = self'.packages.clipit;
  emoji-picker = writeShellApplication {
    name = "emoji-picker";

    runtimeInputs = [
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
writeShellApplication {
  name = "emoji";

  runtimeInputs = [
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

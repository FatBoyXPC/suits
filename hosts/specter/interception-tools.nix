{
  pkgs,
  self',
  ...
}:
{
  services.interception-tools =
    let
      mux = "${pkgs.interception-tools}/bin/mux";
      intercept = "${pkgs.interception-tools}/bin/intercept";
      uinput = "${pkgs.interception-tools}/bin/uinput";
      caps2esc = "${self'.packages.interception-k2k}/bin/caps2esc";
      print2superL = "${self'.packages.interception-k2k}/bin/print2superL";
    in
    {
      enable = true;
      # Note: stringified key names are found here: https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
      udevmonConfig = ''
        - CMD: ${mux} -c caps2esc

        # The `-d` passed to uinput creates a virtual keyboard on the fly that looks
        # like my laptop's keyboard. This is arguably kind of weird as these
        # events may have originated from a completely different type of
        # keyboard. (This is the "living dangerously" documentation from
        # https://gitlab.com/interception/linux/plugins/dual-function-keys#multiple-devices)
        # Note that things get even more complicated if you're interested in
        # "grabbing" the mouse and generating synthetic mouse events too.
        # Fortunately, we're not doing that, but this is useful reading
        # regardless:
        #   - https://gitlab.com/interception/linux/plugins/dual-function-keys/-/issues/31#note_725827382
        #   - https://gitlab.com/interception/linux/tools#hybrid-device-configurations
        - JOB: ${mux} -i caps2esc | ${caps2esc} -m 1 | ${print2superL} | ${uinput} -d /dev/input/by-path/platform-i8042-serio-0-event-kbd

        # Match devices that look like a mouse. Copied from
        # https://gitlab.com/interception/linux/plugins/dual-function-keys#multiple-devices
        # Note: this must go before the keyboard job, as my mouse bizarrely
        # (apparently this isn't so uncommon :() *does* have a bunch of keys
        # that make it look like a keyboard.
        - JOB: ${intercept} $DEVNODE | ${mux} -o caps2esc
          DEVICE:
            EVENTS:
              EV_REL: [REL_WHEEL]
              EV_KEY: [BTN_LEFT]

        # Match devices that look like a keyboard.
        - JOB: ${intercept} -g $DEVNODE | ${mux} -o caps2esc
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK]
      '';
    };
}

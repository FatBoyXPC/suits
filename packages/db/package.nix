{
  fzf,
  gnugrep,
  mycli,
  writeShellApplication,
}:

writeShellApplication {
  name = "db";

  runtimeInputs = [
    fzf
    gnugrep
    mycli
  ];

  text = ''
    server=$(grep -Po '(?<=\[client)[a-zA-Z0-9]+(?=\])' ~/.my.cnf | fzf)

    if [ -n "$server" ]; then
        echo -e "\e]2;$server - db\007"
        mycli --defaults-group-suffix="$server"
    fi
  '';
}

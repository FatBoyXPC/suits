{ fetchzip, lib, buildKodiAddon }:

buildKodiAddon rec {
  pname = "asgard";
  namespace = "plugin.video.asgard";
  version = "1.5.7";
  #https://mylostsoulspace.co.uk/_repo/plugin.video.asgard/plugin.video.asgard-1.5.7.zip

  src = fetchzip {
    url = "https://mylostsoulspace.co.uk/_repo/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-icTwvIL065NOpXyhhu5iB8xMwnyhPQ2Ze2+PiWLGUFs=";
  };

  #propagatedBuildInputs = [
    #bottle
    #requests
    ## This plugin optionally depends on tubed or youtube. Both plugins seem to
    ## have issues with api keys, pick your poison.
    ## tubed
    #youtube
  #];

  meta = with lib; {
    homepage = "";
    description = "AsgardXPC";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}

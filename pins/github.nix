{
  honcho = {
    owner = "plastic-labs";
    repo = "honcho";
    rev = "v3.0.12";
    hash = "sha256-BekiGw5l1eTGbCtGrOcPeJHk/ckJ9pmBJ7r8YXNIMGM=";
    upstream = "https://github.com/plastic-labs/honcho/releases";
    updatePolicy = "Track tagged releases, not branch heads.";
  };

  mpd-url = {
    owner = "suderman";
    repo = "mpd-url";
    rev = "09200dd2dbc3d51312cbf5881efc00678dce9a11";
    hash = "sha256-Wcl+wenrdkGOcjwFEmhCIVHIoZs97oMOrJzP1fbxtUE=";
    upstream = "https://github.com/suderman/mpd-url";
    updatePolicy = "Track the default branch only when that is intentional for this script.";
  };
}

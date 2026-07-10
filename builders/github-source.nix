{
  fetchFromGitHub,
  pin,
}:
fetchFromGitHub {
  inherit (pin) owner repo rev hash;
}

final: prev: {
  suderPins = import ../pins;
  suderpkgs = import ../pkgs {
    pkgs = final;
    pins = final.suderPins;
  };
}

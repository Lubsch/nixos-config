{ hostname, ... }: {
  networking.hostName = hostname;
  environment.enableAllTerminfo = true;
}

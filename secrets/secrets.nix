let
  archUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIS5t/83PuKQJx7NjcWqv4nJsQLpT7GAN9gWDdGnzP9e";
  earlUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvuIIrh2iuj2hX0zIzqLUC/5SD/ZJ3GaLcI1AyHDQuM";
  users = [ archUser earlUser ];

  dukeHost = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQS3GJDwok25r57qdgsuzBpjuHiyB5uyXB1n2FusAgI";
  hosts = [ dukeHost ];
in
{
  "userPassword.age".publicKeys = users ++ hosts;
  "wireless.age".publicKeys = users ++ hosts;
}

let
  archUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIS5t/83PuKQJx7NjcWqv4nJsQLpT7GAN9gWDdGnzP9e";
  users = [ archUser ];
in
{
  "userPassword.age".publicKeys = users;
  "wireless.age".publicKeys = users;
}

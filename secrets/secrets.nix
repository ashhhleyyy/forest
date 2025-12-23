let
  ash_fern =  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGLHqRBcN584SXXa7snrOs89Wy5Jjvsq+GlFXTTBYfp ash@ash-pc";
  # ash_loona = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBEhKflJMcER95s4I+c8Q6zC45LK0ztpXOR2+QWKQVYHEcElxh45hrlUXwVP1nr+OT9AQPhhs+IjNEndRHoSiqxIAAAAEc3NoOg== ash@loona";
  users = [ ash_fern ];
  
  amy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsGEdyz3h9Xn6bmp3v8/SlinWpm7oHtljdScCYJ5iun root@amy";
  jessica = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRZxN0RGV/dTNvXiWUu/ECStDHdS8TVoM4YjaB3dEYq root@jessica";
  systems = [ amy ];
in
{
  "keycloakPostgres.age".publicKeys = users ++ [amy];
  "zulip-redis.age".publicKeys = users ++ [amy];
  "zulip-env.age".publicKeys = users ++ [amy];
  "gts-sandbox.age".publicKeys = users ++ [amy];
  
  "restic-key-amy.age".publicKeys = users ++ [amy];
  "restic-rclone-amy.age".publicKeys = users ++ [amy];
  "restic-password-amy.age".publicKeys = users ++ [amy];

  "restic-key-jessica.age".publicKeys = users ++ [jessica];
  "restic-rclone-jessica.age".publicKeys = users ++ [jessica];
  "restic-password-jessica.age".publicKeys = users ++ [jessica];

  "pds-env.age".publicKeys = users ++ [jessica];
  "mumble-server.age".publicKeys = users ++ [jessica];
  "k3s-token.age".publicKeys = users ++ [jessica];
  "servfail-token.age".publicKeys = users ++ [jessica];
  "garage-admin-token.age".publicKeys = users ++ [jessica];
  "garage-rpc-secret.age".publicKeys = users ++ [jessica];
  "ntfy-url.age".publicKeys = users ++ systems;
}

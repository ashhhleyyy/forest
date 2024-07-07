let
  ash_fern =  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGLHqRBcN584SXXa7snrOs89Wy5Jjvsq+GlFXTTBYfp ash@ash-pc";
  # ash_loona = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBEhKflJMcER95s4I+c8Q6zC45LK0ztpXOR2+QWKQVYHEcElxh45hrlUXwVP1nr+OT9AQPhhs+IjNEndRHoSiqxIAAAAEc3NoOg== ash@loona";
  users = [ ash_fern ];
  
  amy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsGEdyz3h9Xn6bmp3v8/SlinWpm7oHtljdScCYJ5iun root@amy";
  systems = [ amy ];
in
{
  "keycloakPostgres.age".publicKeys = users ++ systems;
  "zulip-redis.age".publicKeys = users ++ systems;
  "zulip-env.age".publicKeys = users ++ systems;
}

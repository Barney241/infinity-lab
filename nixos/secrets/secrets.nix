let
  # User SSH keys - for creating/editing secrets
  barney =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAK+VPy6jJFT7Z6w0e9OV7YMuotkidFXj8ms58YvAdke";

  # Secondary key
  nova =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOctOJ8UpxXARoOsBFnUTuvr6da4JQcL514gPUBdUGME nova";

  orion =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILDH7lfGPiVzBUl3pygy81S5PvHBw+c9ok8t9BsFhopA orion";
  serveros =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAnvXO1xYmlv1oVLGyPaCo+xeG6Qonuglj8VXfGLCZr serveros";
  atlas =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGHhwXVJo+616W9nzJzuwsuzpL7W70gA55+cgIlkDqkj atlas";

  allUsers = [ barney nova ];
  allHosts = [ orion serveros atlas ];
in {
  # User password hash (generate with: mkpasswd -m yescrypt)
  # Must include allHosts so hosts can decrypt at boot!
  "barney-password.age".publicKeys = allUsers ++ allHosts;

  # Jupyter password hash (generate with: python3 -c "from notebook.auth import passwd; print(passwd('yourpassword'))")
  "jupyter-password.age".publicKeys = allUsers ++ allHosts;
}

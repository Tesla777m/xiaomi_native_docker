package docker.authz
default allow = true
allow {
  not deny
}
deny {
  input.Body.HostConfig.CapAdd[_] != null
}
deny {
  input.Body.HostConfig.Privileged == true
}
deny {
  m = input.Body.HostConfig.Binds[_]
  not regex.match("^(/mnt/usb-[^:]+|/var/run/docker.sock):[^:]+$", m)
}
deny {
  m = input.BindMounts[_].Resolved
  not regex.match("^(/mnt/usb-[^:]+|/(var|tmp)/run/docker.sock)$", m)
}

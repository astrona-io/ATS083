---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Summary

Kubernetes leaves pod networking to the container runtime, and the runtime leaves it to a CNI plugin. The runtime finds the plugin by reading a configuration file in `/etc/cni/net.d` and by running the binary of the same name from `/opt/cni/bin`. The kubelet takes no part in this call.

## What you learned

A configuration file is either a `.conf` file with one plugin or a `.conflist` file with a named list of plugins. When the directory holds several files, the runtime sorts them by name and uses the first, which is why files carry a numeric prefix such as `10-`. In a list, each plugin receives the result of the plugin before it as `prevResult`, so a main plugin can create the interface and a later plugin can add port mappings.

The runtime calls the plugin binary once for each change. `ADD` connects a pod sandbox to the network, `DEL` removes it, `CHECK` tests it and `VERSION` reports the specification versions the plugin supports. The runtime passes the operation, the container identifier, the network namespace path, the interface name and the search path in environment variables, and it sends the configuration on standard input. The plugin answers on standard output with a JSON result of interfaces, addresses and routes, or with an error object and a non-zero exit code.

Flannel shows the whole picture. An init container copies the `flannel` binary into `/opt/cni/bin`, a second init container copies the configuration into `10-flannel.conflist`, and the chain runs `flannel` and then `portmap`. The `flannel` plugin reads the subnet of its node from a file and delegates the real work to the `bridge` plugin with the `host-local` address manager.

- The CNI configuration directory is `/etc/cni/net.d`, and the binary directory is `/opt/cni/bin`.
- The first file in name order is the active configuration.
- `type` in a plugin entry is the file name of the binary.
- A plugin exits with 0 on success and prints a JSON result.
- Flannel installs `10-flannel.conflist` with the plugins `flannel` and `portmap`.

<!-- astrona:playground:destroy -->

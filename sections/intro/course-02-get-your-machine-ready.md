# Get Your Machine Ready

The hands-on steps run on your own computer. Each playground and lab starts a private two-node Kubernetes cluster in containers, so nothing touches a shared cluster.

## Tools to install

- The `astrona` command-line tool, which starts, grades and removes the environments.
- A container engine that kind can use, Podman or Docker, with about 4 GiB of free memory.
- `kubectl`, the Kubernetes command-line client.
- `curl` and `python3`, which the start scripts use to download and check files.
- A shell such as `bash` or `zsh`.

kind runs each Kubernetes node as a container, and `astrona` calls it for you. The start scripts download pinned container images and checksum-verified manifests, so the machine needs internet access.

## The commands used every day

Start a playground or a lab with `astrona run --git ssh://git@github.com/astrona-io/ATS083.git -c <environment-path>`. Each page names the environment. Connect `kubectl` to it with `export KUBECONFIG="$(astrona kubeconfig <name>)"`. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

Grade a lab with `astrona submit -c <lab-path>`. Remove an environment with `astrona destroy <name>`. Run one environment at a time, because each cluster needs memory.

## When a start goes wrong

If a start fails, read the last lines of the error. A failed image download usually means the network is not reachable, so run the command again. If memory is short, destroy other environments first. Destroy a half-started environment with `astrona destroy <name>` and start it again.

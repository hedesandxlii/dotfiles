# Dotfiles

This is a collection of my dotfiles, mainly being for helix, tmux & bash

## Quickstart

```sh
$ make
```

## Misc.

### Enabling "OOM killer"

Transient enable:

```
echo 1 | sudo tee /proc/sys/vm/oom_kill_allocating_task
```

Permanent enable:

```
# In the file /etc/sysctl.d/99-enable-oom-kill-allocating-task.conf
vm.oom_kill_allocating_task = 1
```

# Basic Installation

Run one of the following commands in your terminal. You can run via the
command-line with either `curl`, `wget` or another similar tool.

| Method    | Command                                                                                           |
| :-------- | :------------------------------------------------------------------------------------------------ |
| **curl**  | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/b1nary0mega/env-config/refs/heads/main/debian/update.sh)"` |
| **wget**  | `sh -c "$(wget -O- https://raw.githubusercontent.com/b1nary0mega/env-config/refs/heads/main/debian/update.sh)"`   |
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/b1nary0mega/env-config/refs/heads/main/debian/update.sh)"` |

# Manual Inspection

It's a good idea to inspect the install script from projects you don't yet know. You can do that by
downloading the install script first, looking through it so everything looks normal, then running it:

```sh
wget https://raw.githubusercontent.com/b1nary0mega/env-config/refs/heads/main/debian/update.sh
sh update.sh
```

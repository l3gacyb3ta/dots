# dotfile-manager
A manager for dotfiles, using JSON.  

## Build:
Use `sudo make install` to install. Requires crystal and shards.

## Usage
```
dots [commands] <arguments>

COMMANDS:
  add <path to file>   adds the file to the dots config
  copy                 copies all dots to the config dir for backup
  write                copies the backups back to their respective locations
  ls                   list all dots
``

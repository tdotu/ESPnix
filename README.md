# ESPnix
A lua Implementation for some unix commands for the ESP8266
and some useful functions

## License
Simplified BSD license

## functions

### help
Help prints all new commands.

```lua
  help()
```

### load
Load returns the content of a file.
```lua
load(file)
```

###grep
Grep searches a pattern in all files. Uses the built-in function string.find -> currently no regex
```lua
grep(pattern)
```

### line count -> lc
Lc is derived from the unix command wc -l
Lc counts the number of lines of a file.
```lua
lc(file)
```

### ls
Ls lists all files on the flash filesystem.
```lua
ls()
```

### rm
Rm deletes a file from flash.
```lua
rm(filename)
```

### mv
Mv moves/renames a file on the flash filesystem.
```lua
mv(src,dest)
```

### cat
Cat prints the concatenated content of one or more files.
The output of the cat function can not be piped into another function.
Use the load function
```lua
cat(file,...)
```
### touch
Touch creates a file on the flash filesystem.
```lua
touch(file)
```
### fsinfo
fsinfo shows all fileystem Informations
```lua
fsinfo()
```

### cp
Cp copies a file from src to dest
```lua
cp(src,dest)
```
### lsgpio
Lsgpio lists gpio states.
```lua
lsgpio()
```

### ip
Ip shows the current ip configuration
```lua
ip()
```

### lsfiwif
Lists all available wifi networks
```lua
lswifi()
```

### ap
creates a WPA2 secured access point.

```lua
ap(ssid,passwd) 
```


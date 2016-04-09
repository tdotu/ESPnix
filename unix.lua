--Copyright 2016 Simon Diepold <simon.diepold@infinitycoding.de> 
--License: BSD

-- prints all available unix like commands
function help()
  print(
      "load(file)      returns the content of a file\n"..
      "grep(pattern)   searches a pattern in all files\n"..
      "lc(file)        counts the number of lines\n"..
      "ls()            lists all file on flash\n"..
      "rm(file)        deletes a file from flash\n"..
      "mv(src,dest)    renames/moves a file\n"..
      "cat(file,...)   prints one or more files\n"..
      "touch(file)     creates a file\n"..
      "fsinfo()        shows filsystem info\n"..
      "cp(src,dest)    copy file\n"..
      "lsgpio()        lists gpio states\n"..
      "ip()            shows ip config\n"..
      "lswifi()        lists all wifi networks\n"..
      "ap(ssid,passwd) creates a access point"
  )
end

--loads a file into a varriable
function load(src)
  file.open(src,"r")
  local tmp = ""
  while true do
    local line = file.readline()
    if(line == nil) then
      break
    end
    tmp = tmp..line
  end
  return tmp
end

--searches pattern in all files
function grep(pattern)
    local l = file.list()
    for k,v in pairs(l) do
        file.open(k,"r")
        local lineNum = 1
        local filenamePrompt = false
        while true do
            local line = file.readline()
            if(line == nil) then
            break
            end
            if(string.find(line,pattern) ~= nil) then
                if(filenamePrompt == false) then
                    print(k)
                    filenamePrompt = true
                end
                print(lineNum..":"..string.gsub(line,"\n",""))
            end
            lineNum = lineNum+1
        end
    end
end


--counts lines of a file
function lc(src)
  file.open(src,"r")
  local num = 0
  while true do
    line = file.readline()
    if(line == nil) then
      break
    end
    num = num+1
  end
  return num
end


-- lists all files on the ESP memory
function ls()
  local l = file.list()
  res = ""
  for k,v in pairs(l) do
    local len = string.len(k)
    if(len <= 20) then
      res = res..k..string.rep(" ",22-len)..string.format("%6d Bytes\n",v)
    else
      res = res..string.sub(k,0,20)..string.format("%6d Bytes\n",v)
    end
  end
  print(res)
end

-- remove file
function rm(f)
  file.remove(f)
end

--rename/move file
function mv(src,target)
  file.rename(src,target)
end


-- prints the content of files and returns it's content
function cat(...)
  local res=""
  for i,v in ipairs(arg) do
    file.open(v,"r")
    while true do
      line = file.readline()
      if(line == nil) then
        break
      end
      print(line)
    end
  end
end

-- create a file
function touch(f)
    file.open(f,"a+")
    file.write("")
    file.close()
end

-- show information about fhe flash filesystem
function fsinfo()
  remaining, used, total=file.fsinfo()
  print("\nFile system info:\nTotal : "..total.." Bytes\nUsed : "..used.." Bytes\nRemain: "..remaining.." Bytes\n")
end

-- copy files
function cp(src,target)
  file.open(src,"r")
  local tmp = ""
  while true do
    line = file.readline()
    if(line == nil) then
      break
    end
    tmp = tmp..line
  end
  file.close()
  file.open(target,"a+")
  file.write(tmp)
  file.close()
end


--show the current status of all pins
function lsgpio()
  local values = "values|"
  local title =  "  GPIO|"
  for i=0,12,1 do
    title=string.format("%s%2d|",title,i)
    values=string.format("%s%2d|",values,gpio.read(i))
  end
  local border=string.rep("-",string.len(title))
  print(border.."\n"..title.."\n"..border.."\n"..values.."\n"..border)
end


--shows current IP address and station mode
function ip()
  print("ip mask broadcast")
  local m = wifi.getmode();
  if(m == wifi.SOFTAP) then
    print(wifi.ap.getip())
  else
    print(wifi.sta.getip())
  end
end

-- lists the current avialable wifi networks
function lswifi()
  local m = wifi.getmode();
  if(m == wifi.NULLMODE) then
    wifi.setmode(wifi.STATION);
  end
  wifi.sta.getap(function(t)
    for k,v in pairs(t) do
        print(k.." : "..v)
      end
  end)
end

-- setup access point with wpa 2 in a short command
function ap(ssid,passwd)
  if(string.len(passwd) < 8) then
     print("your password must be at leat 8 characters")
     return false
  end
  wifi.setmode(wifi.SOFTAP)
  cfg = {}
  cfg.ssid = ssid
  cfg.pwd = passwd
  wifi.ap.config(cfg)
  wifi.ap.dhcp.start()
end

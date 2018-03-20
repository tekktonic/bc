local sleep = require("socket").sleep
local http = require("socket.http")
local json = require("json")
local statvfs = require("posix.sys.statvfs").statvfs

local server = "http://localhost:8080"


function collect(it)
   local retval = {}
   for entry in it do
      table.insert(retval, entry)
   end
   return retval
end

function map(f, arr)
   local retval = {}
   for _,entry in pairs(arr) do
      retval[#retval + 1] = f(entry)
   end
   return retval
end

function filter(f, arr)
   local retval = {}
   for _,entry in pairs(arr) do
      if f(entry) then
	 table.insert(retval, entry)
      end
   end
end

function get_cpu()
   local f = io.open("/proc/stat", "r")
   local cpuline = f:read()

   local cpu_entries = collect(cpuline:gmatch("%d+"))

   f:close()

   return (cpu_entries[1] + cpu_entries[3]) / (cpu_entries[1] + cpu_entries[3] + cpu_entries[4]) * 100
end


function get_memory()
   local memory_stats = {}
   local mem_entries = map(function(entry)
	                       return entry:match("%d+")
			   end,
      collect(io.lines("/proc/meminfo")))

   memory_stats.max = mem_entries[1]
   memory_stats.used = memory_stats.max - mem_entries[3]
   return memory_stats;
end

function get_root()
   local root_stats = {}
   local info = statvfs("/")
   root_stats.max = (info.f_bsize * info.f_blocks) / 1024
   root_stats.used = root_stats.max - ((info.f_bsize * info.f_bfree) / 1024)


   return root_stats
end

function laptop_step()
   local laptop = {}
   laptop.memory = get_memory()
   laptop.cpu = get_cpu()
   laptop.disk = get_root()

   return laptop
end
-- Register with the server so that we can get a usable ID.
--local id = http.request(server .. "/register")

while true do
   --   http.request(server .. "/" .. laptop.id, json.encode(laptop))
   laptop = laptop_step(laptop)
   print("Current computer status:\n")
   print("CPU: " .. laptop.cpu .. "%\n")
   print("Memory: " .. laptop.memory.used .. "K/" .. laptop.memory.max .. "K\n")
   print("Root: " .. laptop.disk.used .. "K/" .. laptop.disk.max .. "K\n")
   
   sleep(3)

end


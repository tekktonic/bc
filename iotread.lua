local sleep = require("socket").sleep
local http = require("socket.http")
local json = require("json")

local server = "http://localhost:8080"

function generate_laptop(id)
   math.randomseed(os.time())
   retval = {}
   retval.id = id
   retval.fan_rpm = math.random(960) * 10
   retval.temperature = math.random(100)
   retval.cores = math.random(7) + 1
   retval.cpu = math.random(101)

   retval.max_memory = math.random(math.pow(2, 20) + 1 )
   retval.memory_used = math.floor(retval.max_memory * math.random())

   retval.disk_space = math.random(math.pow(2, 49) + 1)
   retval.disk_used = math.floor(retval.disk_space * math.random())

   retval.wifi_signal = math.random(3) + 1
   return retval
end

function laptop_step(last)
   print("Laptop step")
   retval = last
   retval.fan_rpm = math.random(96) * 1000
   retval.temperature = math.random(100)
      
   for core = 1, last.cores do
      retval.cpu = math.random(101)
   end

   retval.memory_used = math.floor(retval.max_memory * math.random())
   retval.disk_used = math.floor(retval.disk_space * math.random())
   
   retval.wifi_signal = math.random(3) + 1

   return retval
end


-- Register with the server so that we can get a usable ID.
local id = http.request(server .. "/register")
local laptop = generate_laptop(80)

print(laptop)
print(laptop.id)
while true do
   http.request(server .. "/" .. laptop.id, json.encode(laptop))
   sleep(3)
   laptop = laptop_step(laptop)
end


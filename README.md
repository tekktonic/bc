# Introduction
BC is a really basic set of programs to simulate an IoT ecosystem. It doesn't do too much pretty stuff, but the central hub is a Lapis application which communicates with its various appliances over a basic REST api. On the appliance side, it's just Lua, Luasockets, and json.lua.
## How to run
1: Install the required dependencies. json.lua is included but in order to run the server you need lsqlite3, lapis, openresty, and nginx. For the applications you need luasocket.
2: Start the server. This should just be `lapis server`.
3: Start some appliances. They just need to be started like any Lua script.
## Appliance Workflow
Once an appliance starts up, it performs a GET on the server's /register. This call then returns an ID (currently just a random 32 bit integer) which the appliance must remember. When the appliance has an update, it sends a JSON POST to /:id where :id is the appliance's id. It's of the following form:
```
{
	"cpu": num,
	"fan_rpm": num,
	"temperature": num,
	"max_memory": num,
	"memory_used": num,
	"disk_space": num,
	"disk_used": num,
	"wifi_signal": num
}	
```

The server application *MAY* use the fixed properties of max\_memory and disk\_space to verify an appliance's identity. That is, if the ID is valid but the maximum memory and disk space don't match, then the server could treat the request identically to a request for an ID that doesn't exis.t


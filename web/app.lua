local lapis = require("lapis")
local util = require("lapis.util")
local console = require("lapis.console")
local json = require("json")

local sql = require("lsqlite3")
local app = lapis.Application()
laptop = false

app:get("/register", function(self)
	   local id = math.random(math.pow(2, 32))
	   local dbh = sql.open("server.db")
	   dbh:exec("insert into table registered values(" .. id .. ");")
	   dbh:close()
end)

app:post("/:id", function(self)
--[[	    local f = io.open("outlog", "w")
	    io.write(f, self.req.params_post .. "\n")
   io.close(f)]]--
	    
end)

app:match("/console", console.make())
return app

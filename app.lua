local lapis = require("lapis")
local util = require("lapis.util")
local json = require("json")

local sql = require("lsqlite3")
local app = lapis.Application()
laptop = false

app:get("/register", function(self)
	   local id = math.random(math.pow(2, 32))
	   local dbh = sql.open("server.db")
	   dbh:exec("insert into table registered values(" .. id .. ");")
	   
end)

app:post("/:id", function(self)
	    
	    io.write(io.stderr, self.req.params_post)
	    
end)

return app

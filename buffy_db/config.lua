Config = {}

--remember, this works for VORP only!
--you must be in the admin or owners group to use these menus due to them using SQL queries. we dont want users running queries because they are taxing on the server and can be abused by malicious people to crash your server.

Config.housingmenu   = true   --list of all syn_housingV2 houses on the server. select one to TP to it

Config.clanmenu      = true   --list of all syn_clan data in the db

Config.listitems     = true   --list of all items in the items table of the database. when you add one via additemmenu, it will appear here but will not be usable until after your next server restart.

Config.additemmenu   = true   --add items to the database. note: you must restart the server to see them usable!

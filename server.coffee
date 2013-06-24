async = require 'async'
dbinit = require './lib/dbinit2'
settings = require './settings'
util = require 'util'
fs = require 'fs'
express = require("express")
app = express()
server = require("http").createServer(app)
io = require('socket.io').listen(server)

#To use with static crap, like images, jquery, etc

app.configure () ->
	#app.set 'view engine', 'jade'
	#app.set 'views', __dirname + '/views'
	app.use(express.static(__dirname, + '/public'));
	console.log __dirname
	#app.use exp.bodyParser()
	#app.use exp.methodOverride()

async.series([
	(callback) ->
		# setup couchdb database connection
		dbinit settings.couchdb, (err, database) ->
			if err
				callback err
			else
				db = database


				callback null

	,(callback) -> 
		# start connect
		server.listen 3000

		app.get "/", (req, res) ->
			res.sendfile __dirname + "/public/index.html"
		console.log "Server Listening on port 3000"
			

	], (err) ->
	# callback error handler
	if err
		console.log "Problem with starting core services; "
		console.log err
		process.exit err
)

io.sockets.on "connection", (socket) ->
	socket.emit "news",
		hello: "world"

	socket.on "my other event", (data) ->
		console.log data





# CouchDB examples from James G
###


db.view 'blog/bydate', (err,result) ->
	if err console.log "oh shit, view is busted"
	else 
		result.forEach (row)->
			console.log row.title
			console.log row._id
			console.log row._rev


db.save ( (err,response) -> 
	if err 
		console.log 'could not delete document '
	else 
		console.log 'document deleted ' + response


db.get ('f1f7a345e7ca9f4ab33ff3d3c4000f92', (err,doc) ->
	console.log doc

	)

###

express = require 'express'
async = require 'async'
dbinit = require './lib/dbinit2'
settings = require './settings'
appserver = require('http').createServer(app)

app = express();

async.series([
	(callback) ->
		# setup couchdb database connection
		dbinit settings.couchdb, (err, database) ->
			if err
				callback err
			else
				db = database

				callback null

	, (callback) -> 
		# start express
		appserver.listen settings.defaultport
		console.log 'Listening on port ' + settings.defaultport
		callback null

], (err) ->
	# callback error handler
	if err
		console.log "Problem with starting core services; "
		console.log err
		process.exit err
)


###

node-pac12
https://github.com/pac12/node-pac12

Copyright (c) 2013 PAC-12
Licensed under the MIT license.

###

'use strict'

events = require './v1/events'

exports.v1 = {
  events: (appId, domain) ->
    new events appId, domain
}

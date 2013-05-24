http = require 'http'
querystring = require 'querystring'

class Events
  version: 1
  format: 'json'

  constructor: (@appId, @domain = "api.schedules.pac-12.com") ->
    if (not appId)
      throw new Error 'You must provide an APP ID'

  list: (params, callback) ->
    this.getResource '/events/list', params, callback

  ###

  HELPER FUNCTIONS

  ###

  getDomain: ->
    return this.domain

  getResource: (pattern, params, callback) ->
    if typeof params is 'function'
      callback = params
      params = {}

    options = this.getHttpOptions pattern, params
    this.performHttpGet options, callback

  getHttpOptions: (pattern, params) ->
    if typeof params is 'undefined'
      params = {}

    params.appId = this.appId
    params.format = @format

    options =
      hostname: @domain
      path: "/v#{@version}#{pattern}?#{querystring.stringify(params)}"

  performHttpGet: (options, callback) ->
    req = http.get options, (res) =>
      res.setEncoding('utf8')
      data = ''

      res.on 'data', (body) ->
        data += body

      res.on 'end', =>
        if 200 isnt res.statusCode
          return callback 'GET returned HTTP ' + res.statusCode

        result = JSON.parse data

        if result.errors
          if result.errors[0] and result.errors[0].message
            return callback result.errors[0].message
          return callback 'Unknown API error'

        callback null, JSON.parse(data)

      req.on 'error', (e) ->
        callback 'Could not get ' + options + ': ' + err.message

module.exports = Events

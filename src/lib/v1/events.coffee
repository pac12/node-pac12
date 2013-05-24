class Events
  constructor: (@appId, @domain = "api.schedules.pac-12.com") ->
    if (not appId)
      throw new Error 'You must provide an APP ID'

  getDomain: ->
    return this.domain

module.exports = Events

class Events
  constructor: (@appId) ->
    if (not appId)
      throw new Error 'You must provide an APP ID'

module.exports = Events

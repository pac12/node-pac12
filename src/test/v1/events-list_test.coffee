'use strict'
should = require 'should'
nock = require 'nock'

Events = require '../../lib/v1/events'

describe 'V1 Events', ->
  describe '#list()', ->
    scope = undefined
    events = new Events 'app-id'

    before ->
      scope = nock('http://api.schedules.pac-12.com')
        .get('/v1/events/list?appId=bad-id&format=json')
        .replyWithFile(200, __dirname + '/replies/app-id-error.txt')
        .get('/v1/events/list?startDate=2013-05-24&endDate=2013-05-24&sportCode=BSB&appId=app-id&format=json')
        .replyWithFile(200, __dirname + '/replies/events-list-200.txt')
        .get('/v1/events/list?sportCode=UNK&appId=app-id&format=json')
        .replyWithFile(200, __dirname + '/replies/events-list-200-empty.txt')

    it 'should be a function', ->
      events.list.should.be.a('function')

    it 'should pass error and no result with bad app id', (done) ->
      badEvents = new Events 'bad-id'
      badEvents.list (err, result) ->
        err.should.match /APP_NO_PERMISSIONS/
        should.not.exist result
        done()

    it 'should pass no error and events as result on 200', (done) ->
      params =
        startDate: '2013-05-24'
        endDate: '2013-05-24'
        sportCode: 'BSB'

      events.list params, (err, result) ->
        should.not.exist err
        result.should.be.a 'object'
        result.events.should.be.an.instanceOf Array
        result.events[0].sport.should.be.a 'object'
        result.events[0].sport.code.should.match /BSB/
        result.events[0].homeSchool.should.be.a 'object'
        result.events[0].homeSchool.ncaaAbbr.should.match /ORST/
        result.events[0].awaySchool.should.be.a 'object'
        result.events[0].awaySchool.ncaaAbbr.should.match /WSU/
        done()

    it 'should pass no error and empty events as result on 200 and no events', (done) ->
      params =
        sportCode: 'UNK'

      events.list params, (err, result) ->
        should.not.exist err
        result.should.be.a 'object'
        result.events.should.be.an.instanceOf Array
        result.events.should.be.empty
        done()

    after ->
      scope.done()

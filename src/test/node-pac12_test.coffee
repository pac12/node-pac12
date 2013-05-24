'use strict'

node_pac12 = require('../lib/node-pac12.js')

describe 'Node PAC-12 API', ->
  describe 'v1', ->

    it 'should be an object', ->
      node_pac12.v1.should.be.a('object')

    it 'should have an Events function', ->
      node_pac12.v1.events.should.be.a('function')

    describe '#events()', ->

      it 'should return an Events object', ->
        node_pac12.v1.events('app-id').should.be.a('object')

      it 'should throw an error without app id', ->
        (->
          node_pac12.v1.events()
        ).should.throwError(/You must provide an APP ID/)

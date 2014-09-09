expect = require('chai').expect
slotMachine = require('../../lib/slotMachine')

describe 'SlotMachine', ->
  files = ['file1', 'file2', 'file3']

  describe 'slots an identifier', ->
    it 'pulls an empty string', ->
      expect(slotMachine.pull(files, '')).to.be.ok

    it 'pulls a single character string', ->
      expect(slotMachine.pull(files, 'a')).to.be.ok

    it 'always pulls a string to the same image', ->
      for run in [1..100]
        image = slotMachine.pull(files, 'foo')

        expect(image).to.equal('file1')

    it 'always pulls within the given set of files', ->
      for run in [1..100]
        randomString = Math.random().toString(30).substring(2)
        image = slotMachine.pull(files, randomString)

        expect(files).to.include(image)

expect = require('chai').expect
SlotMachine = require('../../lib/slotMachine')

describe 'SlotMachine', ->
  slotMachine = files = null

  beforeEach ->
    files = ['file1', 'file2', 'file3', 'file4']
    slotMachine = new SlotMachine(files)

  describe 'slotting an identifier', ->
    it 'pulls an empty string', ->
      expect(slotMachine.pull('')).to.be.ok

    it 'pulls a single character string', ->
      expect(slotMachine.pull('a')).to.be.ok

    it 'always pulls a string to the same image', ->
      for run in [1..100]
        image = slotMachine.pull('foo')

        expect(image).to.equal('file4')

    it 'always pulls within the given set of files', ->
      for run in [1..100]
        randomString = Math.random().toString(30).substring(2)
        image = slotMachine.pull(randomString)

        expect(files).to.include(image)

  describe 'initializing with a hashing function', ->
    HashingFunctions = require('../../lib/hashingFunctions')
    customSlotMachine = null

    beforeEach ->
      customSlotMachine = new SlotMachine files, HashingFunctions.product

    it 'pulls a string to the same image', ->
      for run in [1..100]
        image = customSlotMachine.pull('string')

        expect(image).to.equal('file3')

    it 'pulls to a different string than the default slotMachine', ->
      expect(customSlotMachine.pull('string'))
        .not.to.equal(slotMachine.pull('string'))

    it 'pulls to different strings', ->
      expect(customSlotMachine.pull('string'))
        .not.to.equal(customSlotMachine.pull('foo'))

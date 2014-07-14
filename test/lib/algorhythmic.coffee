expect = require('chai').expect
algorhythm = require('../../lib/algorhythmic')

describe 'Algorhythmic', ->
  describe 'bucketing an identifier', ->
    bucket = randomString = null

    it 'buckets an empty string', ->
      expect(algorhythm.convert('')).to.be.ok

    it 'buckets a single character string', ->
      expect(algorhythm.convert('a')).to.be.ok

    it 'always converts a string to the same bucket', ->
      for run in [1..100]
        bucket = algorhythm.convert('foo')

        expect(bucket).to.equal(5)

    it 'always buckets within the given range', ->
      for run in [1..100]
        randomString = Math.random().toString(30).substring(2)
        bucket = algorhythm.convert(randomString)

        expect(bucket).to.be.within(1,10)

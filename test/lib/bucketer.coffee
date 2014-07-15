expect = require('chai').expect
bucketer = require('../../lib/bucketer')

describe 'Bucketer', ->
  describe 'bucketing an identifier', ->
    bucket = randomString = null

    it 'buckets an empty string', ->
      expect(bucketer.convert('')).to.be.ok

    it 'buckets a single character string', ->
      expect(bucketer.convert('a')).to.be.ok

    it 'always converts a string to the same bucket', ->
      for run in [1..100]
        bucket = bucketer.convert('foo')

        expect(bucket).to.equal(5)

    it 'always buckets within the given range', ->
      for run in [1..100]
        randomString = Math.random().toString(30).substring(2)
        bucket = bucketer.convert(randomString)

        expect(bucket).to.be.within(1,10)

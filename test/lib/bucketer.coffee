expect = require('chai').expect
Bucketer = require('../../lib/bucketer')

describe 'Bucketer', ->
  bucketer = numBuckets = null

  beforeEach ->
    numBuckets = 10
    bucketer = new Bucketer(numBuckets)

  describe 'bucketing an identifier', ->
    it 'buckets an empty string', ->
      expect(bucketer.bucketFor('')).to.be.ok

    it 'buckets a single character string', ->
      expect(bucketer.bucketFor('a')).to.be.ok

    it 'always buckets a string to the same bucket', ->
      for run in [1..100]
        bucket = bucketer.bucketFor('foo')

        expect(bucket).to.equal(5)

    it 'always buckets within the given range', ->
      for run in [1..100]
        randomString = Math.random().toString(30).substring(2)
        bucket = bucketer.bucketFor(randomString)

        expect(bucket).to.be.within(1, numBuckets)

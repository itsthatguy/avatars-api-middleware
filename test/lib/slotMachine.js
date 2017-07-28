const expect = require('chai').expect;
import SlotMachine from '../../src/lib/slotMachine';

describe('SlotMachine', function() {
  let slotMachine;
  let files;

  beforeEach(function() {
    files = Array(5)
    .fill()
    .map((_, i) => 'file' + (i + 1));

    slotMachine = new SlotMachine(files);
  });

  describe('slotting an identifier', function() {
    it('pulls an empty string', function() {
      return expect(slotMachine.pull('')).to.be.ok;
    });

    it('pulls a single character string', function() {
      return expect(slotMachine.pull('a')).to.be.ok;
    });

    it('always pulls a string to the same image', function() {
      Array(100)
      .fill()
      .forEach(() => {
        const image = slotMachine.pull('foo');
        expect(image).to.equal('file3');
      });
    });

    it('always pulls within the given set of files', function() {
      Array(100)
      .fill()
      .forEach(() => {
        const randomString = Math.random().toString(30).substring(2);
        const image = slotMachine.pull(randomString);
        expect(files).to.include(image);
      });
    });
  });

  describe('initializing with a hashing function', function() {
    const { sumAndDiff } = require('../../src/lib/hashingFunctions');
    let customSlotMachine = null;

    beforeEach(function() {
      customSlotMachine = new SlotMachine(files, sumAndDiff);
    });

    it('pulls a string to the same image', function() {
      Array(100)
      .fill()
      .forEach(() => {
        const image = customSlotMachine.pull('string');
        expect(image).to.equal('file2');
      });
    });

    it('pulls to a different string than the default slotMachine', function() {
      expect(customSlotMachine.pull('string')).not.to.equal(slotMachine.pull('string'));
    });

    it('pulls to different strings', function() {
      expect(customSlotMachine.pull('string')).not.to.equal(customSlotMachine.pull('foo'));
    });
  });
});

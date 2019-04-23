import { expect } from 'chai';
import { parseSize } from '../../src/lib/imaging';

describe('imager', () => {
  describe('parseSize', () => {
    it('defaults to 400x400', () => {
      expect(parseSize()).to.eql({ height: 400, width: 400 });
      expect(parseSize('')).to.eql({ height: 400, width: 400 });
      expect(parseSize('0')).to.eql({ height: 400, width: 400 });
    });

    it('sets a square if one size is specified', () => {
      expect(parseSize('50')).to.eql({ height: 50, width: 50 });
    });

    it('clamps to 40 if smaller', () => {
      expect(parseSize('10x50')).to.eql({ height: 50, width: 40 });
      expect(parseSize('100x20')).to.eql({ height: 40, width: 100 });
    });

    it('clamps to 400 if bigger', () => {
      expect(parseSize('500')).to.eql({ height: 400, width: 400 });
      expect(parseSize('500x200')).to.eql({ height: 200, width: 400 });
      expect(parseSize('100x500')).to.eql({ height: 400, width: 100 });
    });
  });
});

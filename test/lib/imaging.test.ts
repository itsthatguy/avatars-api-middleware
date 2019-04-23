import { expect } from 'chai';
import { toSize } from '../../src/lib/imaging';

describe('imager', () => {
  describe('toSize', () => {
    it('defaults to 400x400', () => {
      expect(toSize()).to.eql({ height: 400, width: 400 });
      expect(toSize('')).to.eql({ height: 400, width: 400 });
      expect(toSize('0')).to.eql({ height: 400, width: 400 });
    });

    it('sets a square if one size is specified', () => {
      expect(toSize('50')).to.eql({ height: 50, width: 50 });
    });

    it('clamps to 40 if smaller', () => {
      expect(toSize('10x50')).to.eql({ height: 50, width: 40 });
      expect(toSize('100x20')).to.eql({ height: 40, width: 100 });
    });

    it('clamps to 400 if bigger', () => {
      expect(toSize('500')).to.eql({ height: 400, width: 400 });
      expect(toSize('500x200')).to.eql({ height: 200, width: 400 });
      expect(toSize('100x500')).to.eql({ height: 400, width: 100 });
    });
  });
});

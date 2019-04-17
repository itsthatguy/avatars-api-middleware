import { expect } from 'chai';

import { allNames, allPaths } from '../../src/lib/imageFiles';

describe('allNames', () => {
  it('lists all image names of a particular type', () => {
    expect(allNames('eyes')).to.include.members(['eyes1', 'eyes2']);
  });
});

describe('allPaths', () => {
  it('lists all image paths of a particular type', () => {
    const [mouthPath] = allPaths('mouth');

    expect(mouthPath).to.match(/src\/img\/mouth\/mouth\d+.png/);
  });
});

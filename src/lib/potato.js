// our libs
import { sumAndDiff } from './hashingFunctions';
import { allPaths }       from './imageFiles';
import SlotMachine      from './slotMachine';

const colors = [
  '#81bef1',
  '#ad8bf2',
  '#bff288',
  '#de7878',
  '#a5aac5',
  '#6ff2c5',
  '#f0da5e',
  '#eb5972',
  '#f6be5d',
];

class Potato {
  constructor() {
    this.colorMachine = new SlotMachine(colors);
    this.eyesMachine  = new SlotMachine(allPaths('eyes'));
    this.noseMachine  = new SlotMachine(allPaths('nose'));
    this.mouthMachine = new SlotMachine(allPaths('mouth'), sumAndDiff);
  }

  // Construct Faces Parts
  parts(string) {
    return {
      color : this.colorMachine.pull(string),
      eyes  : this.eyesMachine.pull(string),
      nose  : this.noseMachine.pull(string),
      mouth : this.mouthMachine.pull(string),
    };
  }
}

export default new Potato();

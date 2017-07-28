import { sum } from './hashingFunctions';

class SlotMachine {
  constructor(slots, hashingFn) {
    this.slots = slots;
    this.numSlots = this.slots.length;
    this.hashingFn = hashingFn || sum;
  }

  pull(string) {
    const str = string.replace(/\.(png|jpg|gif|)$/g, '');
    const stringArray = str.split('');
    return this.slots[this._indexFor(stringArray)];
  }

  _indexFor(array) {
    const intArray = array.map(this._getCharInt);
    const index = (this.hashingFn(intArray) + intArray.length) % this.numSlots;
    return Math.abs(index);
  }

  _getCharInt(char) {
    return parseInt(char.charCodeAt(0) || 0, 10);
  }
}

export default SlotMachine;

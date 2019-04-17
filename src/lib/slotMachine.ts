import { sum } from './hashingFunctions';

class SlotMachine<T> {
  private numSlots: number;

  constructor(private slots: T[], private hash = sum) {
    this.numSlots = slots.length;
  }

  pull(string) {
    const str = string.replace(/\.(png|jpg|gif|)$/g, '');
    const stringArray = str.split('');
    return this.slots[this.indexFor(stringArray)];
  }

  private indexFor(array) {
    const intArray = array.map(this.getCharInt);
    const index = (this.hash(intArray) + intArray.length) % this.numSlots;
    return Math.abs(index);
  }

  private getCharInt(char) {
    return parseInt(char.charCodeAt(0) || 0, 10);
  }
}

export default SlotMachine;

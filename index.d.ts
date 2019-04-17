type ImageType = 'eyes' | 'nose' | 'mouth';
type FaceParts = ImageType | 'color';

interface Face {
  color: string;
  eyes: string;
  nose: string;
  mouth: string;
}

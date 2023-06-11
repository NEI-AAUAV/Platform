type Companion = {
  dish: string;
  allergies: string;
};

type Person = {
  id: number;
  allergies: string;
  dish: string;
  confirmed: boolean;
  companions: Companion[];
};

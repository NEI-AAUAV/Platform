type Person = {
  id: number;
  allergies: string;
  dish: string;
  confirmed: boolean;
  companions: {
    dish: string;
    allergies: string;
  }[];
};

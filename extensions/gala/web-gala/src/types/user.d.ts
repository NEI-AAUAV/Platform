type User = {
  _id: number;
  matriculation: number;
  nmec: number;
  email: string;
  name: string;
  has_payed: boolean;
};

type UserExtended = User & Person;

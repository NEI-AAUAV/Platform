type Vote = {
  _id: number;
  category: string;
  options: string[];
  scores: number[];
  already_voted: number | null;
};

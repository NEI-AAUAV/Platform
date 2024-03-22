export type RankByOptions =
  | "Vitórias"
  | "Golos/Jogos/Sets"
  | "Vitórias dos Jogos/Sets"
  | "Pontuação Costumizada";

export type Participant = {
  name: string;
  id: number;
  team_id: number;
  image: string;
};

export type Course = {
  name: string;
  short: string;
  color: string;
  id: number;
  image: string;
};

export type Team = {
  name: string;
  course_id: number;
  id: number;
  modality_id?: number;
  image?: string;
  course?: Course;
  participants?: Participant[];
};

export type Match = {
  team1_id: number;
  team2_id: number;
  score1: number;
  score2: number;
  games1: number[];
  games2: number[];
  winner: number;
  forfeiter: number;
  live: boolean;
  date: string;
  round: number;
  team1_prereq_match_id: number;
  team2_prereq_match_id: number;
  team1_is_prereq_match_winner: boolean;
  team2_is_prereq_match_winner: boolean;
  id: number;
  team1: Team;
  team2: Team;
};

export type Group = {
  name: string;
  id: number;
  competition_id: number;
  number: number;
  matches: Match[];
  teams: Team[];
};

export type Competition = {
  number: number;
  division: number;
  name: string;
  started: boolean;
  public: boolean;
  _metadata:
    | { rank_by: RankByOptions; system: string; third_place_match: boolean }
    | {
        rank_by: RankByOptions;
        system: string;
        play_each_other_times: number;
        pts_win: number;
        pts_win_tiebreak: number;
        pts_tie: number;
        pts_loss: number;
        pts_loss_tiebreak: number;
        pts_ff: number;
        ff_score_for: number;
        ff_score_agst: number;
      }
    | {
        rank_by: RankByOptions;
        system: string;
        rounds: number;
        pts_bye: number;
      };
  id: number;
  modality_id: number;
  groups: Group[];
};

export type Modality = {
  year: number;
  type: string;
  frame: string;
  sport: string;
  id: number;
  competitions?: Competition[];
  teams?: Team[];
};

export type SportTab = {
  name: string;
  url: string;
  isAdminOnly: boolean;
};

export type TabsProps = SportTab[];

export type ModalitiesByYearAndFrame = {
  [year: number]: { [sport: string]: Modality[] };
};
export type ModalityFrames = { frame: string; id: number };

from typing import Annotated, Literal, Optional, List, Union

from pydantic import BaseModel, ConfigDict, Field, RootModel, StringConstraints

from app.utils import EnumList, ValidateFromJson
from .group import Group


class SystemEnum(str, EnumList):
    SINGLE_ELIMINATION = "Eliminação Direta"
    ROUND_ROBIN = "Todos Contra Todos"
    SWISS = "Suiço"


class RankByEnum(str, EnumList):
    WINS = "Vitórias"
    SCORES = "Golos/Jogos/Sets"
    GAMES_WINS = "Vitórias dos Jogos/Sets"
    PTS_CUSTOM = "Pontuação Costumizada"


class TiebreakEnum(str, EnumList):
    FF = (
        "Faltas de Comparência",
        "A equipa que tiver menor número faltas de comparência.",
    )
    PTS_H2H = (
        "Pontuação entre Empatados",
        "O resultado do(s) jogo(s) entre todas as equipas empatadas.",
    )
    WIN_LOSS_DIFF_H2H = (
        "Diferença de Partidas Ganhas e Perdidas entre Empatados",
        "Diferença entre o número de partidas ganhas e perdidas"
        " entre os atletas empatados.",
    )
    SCORE_DIFF_H2H = (
        "Diferença de Golos/Jogos/Sets entre Empatados",
        "Diferença entre o número de golos/jogos/sets ganhos e perdidos"
        " entre as equipas empatadas.",
    )
    SCORE_H2H = (
        "Golos/Jogos/Sets entre Empatados",
        "O maior número de golos/jogos/sets entre as equipas empatadas.",
    )
    WIN_LOSS_DIFF = (
        "Diferença de Partidas Ganhas e Perdidas",
        "Diferença entre o número de partidas ganhas e perdidas"
        " entre as equipas empatados.",
    )
    SCORE_DIFF = (
        "Diferença de Golos/Jogos/Sets",
        "Diferença entre o número de golos/jogos/sets ganhos e perdidos"
        " em toda a fase.",
    )
    PTS_DISCIPLINARY = ("Pontos Disciplinares", "")
    SCORE = ("Golos/Jogos/Sets", "O maior número de golos/jogos/sets em toda a fase.")
    RANDOM = ("Sorteio", "")

    @classmethod
    def list(cls):
        return list(map(lambda c: (c.value, c.description), cls))

    def __new__(cls, value, description):
        obj = str.__new__(cls)
        obj._value_ = value
        obj.description = description
        return obj


class SystemBase(BaseModel):
    rank_by: RankByEnum = RankByEnum.WINS


class SingleElimination(SystemBase):
    system: Literal[SystemEnum.SINGLE_ELIMINATION]
    third_place_match: bool = False


class RoundRobin(SystemBase):
    system: Literal[SystemEnum.ROUND_ROBIN]
    play_each_other_times: Literal[1, 2, 3]
    pts_win: int = 0
    pts_win_tiebreak: int = 0
    pts_tie: int = 0
    pts_loss_tiebreak: int = 0
    pts_loss: int = 0
    pts_ff: int = 0
    ff_score_for: int = 0
    ff_score_agst: int = 0
    # tiebreaks: List[TiebreakEnum] = []
    #  participants compete in each group
    #  participants advance from each group


class Swiss(SystemBase):
    system: Literal[SystemEnum.SWISS]
    rounds: int
    pts_bye: int = 0


class Metadata(RootModel, ValidateFromJson):
    root: Annotated[
        Union[SingleElimination, RoundRobin, Swiss], Field(..., discriminator="system")
    ]


class CompetitionBase(BaseModel):
    number: Optional[int] = None
    division: Optional[int] = None
    name: Annotated[str, StringConstraints(max_length=50)]
    started: bool = False  # when False, can only add, update, swap teams
    public: bool = False
    metadata: Metadata = Field(alias="_metadata")


class CompetitionCreate(CompetitionBase):
    modality_id: int
    # TODO: how and where should groups be created


class CompetitionUpdate(CompetitionBase):
    name: Optional[Annotated[str, StringConstraints(max_length=50)]] = None
    started: Optional[bool] = None
    public: Optional[bool] = None


class Competition(CompetitionBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    modality_id: int
    groups: List[Group]

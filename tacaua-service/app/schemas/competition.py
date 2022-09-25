from typing import Optional, List

from pydantic import BaseModel, constr

from app.utils import EnumList
from .group import Group


class SystemEnum(str, EnumList):
    SINGLE_ELIMINATION = 'Eliminação Direta'
    ROUND_ROBIN = 'Todos Contra Todos'
    SWISS = 'Suiço'


class RankByEnum(str, EnumList):
    WINS = 'Vitórias'
    SCORES = 'Golos/Jogos/Sets'
    GAMES_WINS = 'Vitórias dos Jogos/Sets'
    PTS_CUSTOM = 'Pontuação Costumizada'


class TiebreakEnum(str, EnumList):
    FF = (
        'Faltas de Comparência',
        "A equipa que tiver menor número faltas de comparência.")
    PTS_H2H = (
        'Pontuação entre Empatados',
        "O resultado do(s) jogo(s) entre todas as equipas empatadas.")
    WIN_LOSS_DIFF_H2H = (
        'Diferença de Partidas Ganhas e Perdidas entre Empatados',
        "Diferença entre o número de partidas ganhas e perdidas"
        " entre os atletas empatados.")
    SCORE_DIFF_H2H = (
        'Diferença de Golos/Jogos/Sets entre Empatados',
        "Diferença entre o número de golos/jogos/sets ganhos e perdidos"
        " entre as equipas empatadas.")
    SCORE_H2H = (
        'Golos/Jogos/Sets entre Empatados',
        "O maior número de golos/jogos/sets entre as equipas empatadas.")
    WIN_LOSS_DIFF = (
        'Diferença de Partidas Ganhas e Perdidas',
        "Diferença entre o número de partidas ganhas e perdidas"
        " entre as equipas empatados.")
    SCORE_DIFF = (
        'Diferença de Golos/Jogos/Sets',
        "Diferença entre o número de golos/jogos/sets ganhos e perdidos"
        " em toda a fase.")
    PTS_DISCIPLINARY = (
        'Pontos Disciplinares',
        "")
    SCORE = (
        'Golos/Jogos/Sets',
        "O maior número de golos/jogos/sets em toda a fase.")
    RANDOM = (
        'Sorteio',
        "")

    @classmethod
    def list(cls):
        return list(map(lambda c: (c.value, c.description), cls))
    
    def __new__(cls, value, description):
        obj = str.__new__(cls)
        obj._value_ = value
        obj.description = description
        return obj


# class Metadata(BaseModel):
#     system: SystemEnum


# class SingleEliminationMetadata(Metadata):
#     system = SystemEnum.SINGLE_ELIMINATION


# pts_win = Column(SmallInteger, default=0)
# pts_win_tiebreak = Column(SmallInteger, default=0)
# pts_tie = Column(SmallInteger, default=0)
# pts_loss_tiebreak = Column(SmallInteger, default=0)
# pts_loss = Column(SmallInteger, default=0)
# pts_ff = Column(SmallInteger, default=0)
# ff_scored_for = Column(SmallInteger, default=0)
# ff_scored_agst = Column(SmallInteger, default=0)
# bye
#


class CompetitionBase(BaseModel):
    division: Optional[int]
    name: constr(max_length=50)
    system: SystemEnum
    rank_by: RankByEnum
    # tiebreaks: List[TiebreakEnum] = []
    started: bool = False
    public: bool = False
    # metadata: Dict[str, str] = Field(alias='metadata_')


class CompetitionCreate(CompetitionBase):
    modality_id: int
    pass


class CompetitionUpdate(CompetitionBase):
    name: Optional[constr(max_length=50)]
    system: Optional[SystemEnum]
    rank_by: Optional[RankByEnum]
    tiebreaks: Optional[List[TiebreakEnum]]
    started: Optional[bool] # TODO: será q ele mete none?
    public: Optional[bool]


class Competition(CompetitionBase):
    id: int
    modality_id: int
    groups: List[Group]

    class Config:
        orm_mode = True

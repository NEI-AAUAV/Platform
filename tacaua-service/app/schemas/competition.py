from typing import Any, Optional
from pydantic import BaseModel, Field

from enum import Enum
from typing_extensions import Annotated


class TypeEnum(str, Enum):
    COLECTIVE = 'Coletiva'
    INDIVIDUAL = 'Individual'


class RankByEnum(str, Enum):
    WINS = 'Vitórias'
    SCORES = 'Golos/Jogos/Sets'
    GAMES_WINS = 'Vitórias dos Jogos/Sets'
    PTS_CUSTOM = 'Pontuação Costumizada'


class TiebreakEnum(str, Enum):
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

    def __new__(cls, value, description):
        obj = str.__new__(cls)
        obj._value_ = value
        obj.description = description
        return obj

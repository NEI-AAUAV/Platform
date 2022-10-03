import pytest
import app.crud as crud


@pytest.mark.parametrize("input,expected", [
    (9, [1, 4, 2, 1]),
    (8, [4, 2, 1]),
    (7, [3, 2, 1]),
    (6, [2, 2, 1]),
    (5, [1, 2, 1]),
    (4, [2, 1]),
    (3, [1, 1]),
    (2, [1]),
    (1, []),
    (0, []),
])
def test_get_matches_per_round(input, expected):
    assert crud.group.get_matches_per_round(input) == expected

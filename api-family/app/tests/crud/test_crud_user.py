"""User collection: queries, role enrichment, the family tree and image upload."""

from io import BytesIO
from unittest.mock import MagicMock

import pytest
from PIL import Image

from app.crud import crud_user as module
from app.crud.crud_user import user as crud
from app.schemas.user import UserCreate, UserUpdate
from app.tests.factories import make_role, make_user, make_user_role


def _ids(users) -> list[int]:
    return [u["_id"] for u in users]


# ------------------------------------------------------------------ create/read


def test_create_assigns_next_id_after_current_maximum() -> None:
    make_user(10, "Existing")

    created = crud.create(obj_in=UserCreate(name="Novo Aluno", sex="M"))

    assert created["_id"] == 11


def test_first_user_gets_id_one() -> None:
    assert crud.create(obj_in=UserCreate(name="Solo", sex="F"))["_id"] == 1


def test_faina_name_defaults_to_last_word_of_name() -> None:
    created = crud.create(obj_in=UserCreate(name="Maria José Costa", sex="F"))

    assert created["faina_name"] == "Costa"


def test_explicit_faina_name_is_kept() -> None:
    created = crud.create(obj_in=UserCreate(name="Maria Costa", sex="F", faina_name="Mimi"))

    assert created["faina_name"] == "Mimi"


def test_get_and_get_by_nmec_and_exists() -> None:
    make_user(1, "A", nmec=123)

    assert crud.get(1)["name"] == "A"
    assert crud.get_by_nmec(123)["_id"] == 1
    assert crud.get_by_nmec(999) is None
    assert crud.exists(1) is True
    assert crud.exists(2) is False


def test_update_changes_only_given_fields() -> None:
    make_user(1, "Old Name", nmec=5)

    updated = crud.update(id=1, obj_in=UserUpdate(name="New Name"))

    assert (updated["name"], updated["nmec"]) == ("New Name", 5)


def test_empty_update_returns_user_and_unknown_returns_none() -> None:
    make_user(1, "A")

    assert crud.update(id=1, obj_in=UserUpdate())["name"] == "A"
    assert crud.update(id=99, obj_in=UserUpdate(name="x")) is None


def test_update_can_clear_patrao_explicitly() -> None:
    make_user(1, "Patrao")
    make_user(2, "Child", patrao_id=1)

    updated = crud.update(id=2, obj_in=UserUpdate(patrao_id=None))

    assert updated["patrao_id"] is None


def test_delete() -> None:
    make_user(1, "A")

    assert crud.delete(id=1) is True
    assert crud.delete(id=1) is False


# ---------------------------------------------------------------------- listing


@pytest.fixture
def people() -> None:
    make_user(1, "Ana Silva", start_year=18, nmec=1001)
    make_user(2, "Bruno Costa", start_year=19, patrao_id=1, nmec=1002)
    make_user(3, "Carla Dias", sex="F", start_year=20, patrao_id=1)
    make_user(4, "Diogo Silva", start_year=20, patrao_id=2)


def test_default_listing_is_sorted_by_name(people) -> None:
    assert _ids(crud.get_multi()) == [1, 2, 3, 4]


@pytest.mark.parametrize(
    "sort_by,order,expected",
    [
        ("name", "desc", [4, 3, 2, 1]),
        ("id", "asc", [1, 2, 3, 4]),
        ("id", "desc", [4, 3, 2, 1]),
        ("year", "desc", [3, 4, 2, 1]),
        ("nmec", "asc", [3, 4, 1, 2]),
        ("bogus", "asc", [1, 2, 3, 4]),  # unknown key falls back to name
    ],
)
def test_sort_keys_are_mapped_and_unknown_ones_fall_back(
    people, sort_by, order, expected
) -> None:
    got = _ids(crud.get_multi(sort_by=sort_by, order=order))

    if sort_by == "nmec":
        # users without nmec sort first ascending; only assert relative order
        assert got.index(1) < got.index(2)
    elif sort_by == "year":
        assert got[-1] == 1
        assert set(got[:2]) == {3, 4}
    else:
        assert got == expected


def test_filters_by_from_year_exact_year_and_patrao(people) -> None:
    assert set(_ids(crud.get_multi(start_year_gte=20))) == {3, 4}
    assert set(_ids(crud.get_multi(year=19))) == {2}
    assert set(_ids(crud.get_multi(patrao_id=1))) == {2, 3}


def test_exact_year_wins_over_minimum_year(people) -> None:
    assert set(_ids(crud.get_multi(start_year_gte=20, year=18))) == {1}


def test_pagination(people) -> None:
    assert _ids(crud.get_multi(skip=1, limit=2)) == [2, 3]


def test_search_is_case_insensitive_substring_on_name(people) -> None:
    assert set(_ids(crud.get_multi(search="silva"))) == {1, 4}
    assert set(_ids(crud.get_multi(search="  CARLA "))) == {3}
    assert crud.get_multi(search="nobody") == []


def test_numeric_search_also_matches_id_and_nmec(people) -> None:
    assert set(_ids(crud.get_multi(search="2"))) == {2}  # id 2
    assert set(_ids(crud.get_multi(search="1001"))) == {1}  # nmec


def test_search_treats_regex_metacharacters_literally(people) -> None:
    make_user(5, "Zé (Zeca) Santos")

    assert _ids(crud.get_multi(search="(")) == [5]
    assert crud.get_multi(search=".*") == []  # would match everything if interpreted as a regex
    assert crud.count(search="(Zeca)") == 1


def test_count_applies_same_filters(people) -> None:
    assert crud.count() == 4
    assert crud.count(search="silva") == 2
    assert crud.count(year=20) == 2
    assert crud.count({"sex": "F"}) == 1


def test_role_filter_matches_role_and_all_descendants_by_prefix() -> None:
    make_user(1, "A")
    make_user(2, "B")
    make_user(3, "C")
    make_user_role(1, ".1.", 20)
    make_user_role(2, ".1.5.", 20)
    make_user_role(3, ".2.", 20)

    assert set(_ids(crud.get_multi(role_id=".1."))) == {1, 2}
    assert crud.count(role_id=".1.") == 2
    assert set(_ids(crud.get_multi(role_id=".1.5."))) == {2}


def test_role_year_narrows_the_role_filter() -> None:
    make_user(1, "A")
    make_user(2, "B")
    make_user_role(1, ".1.", 20)
    make_user_role(2, ".1.", 21)

    assert set(_ids(crud.get_multi(role_id=".1.", role_year=21))) == {2}


def test_role_filter_is_combined_with_other_filters() -> None:
    make_user(1, "A", start_year=18)
    make_user(2, "B", start_year=19)
    make_user_role(1, ".1.", 20)
    make_user_role(2, ".1.", 20)

    assert set(_ids(crud.get_multi(role_id=".1.", year=19))) == {2}
    assert set(_ids(crud.get_multi(role_id=".1.", search="a"))) == {1}


def test_role_filter_with_regex_metacharacters_is_escaped() -> None:
    make_user(1, "A")
    make_user_role(1, ".1.", 20)

    assert crud.get_multi(role_id=".*") == []


def test_children_roots_years_and_range(people) -> None:
    assert {u["_id"] for u in crud.get_children(1)} == {2, 3}
    assert crud.get_children(4) == []
    assert [u["_id"] for u in crud.get_roots()] == [1]
    assert crud.get_years() == [20, 19, 18]
    assert crud.get_year_range() == (18, 20)
    assert len(crud.get_all()) == 4


def test_year_helpers_on_empty_database() -> None:
    assert crud.get_years() == []
    assert crud.get_year_range() == (0, 0)


def test_years_ignore_users_without_start_year() -> None:
    make_user(1, "A", start_year=None)
    make_user(2, "B", start_year=19)

    assert crud.get_years() == [19]
    assert crud.get_year_range() == (19, 19)


def test_get_existing_ids_returns_only_present_ones(people) -> None:
    assert sorted(crud.get_existing_ids([1, 3, 99])) == [1, 3]
    assert crud.get_existing_ids([]) == []


# -------------------------------------------------------------- role enrichment


@pytest.fixture
def org() -> None:
    make_role(".1.", "Faina", short="FAINA", icon="faina.svg", year_display_format="academic")
    # no own format => inherited from the nearest ancestor that defines one
    make_role(".1.2.", "Conselho", super_roles=".1.", short=None, year_display_format=None)
    make_role(
        ".1.2.3.", "Mestre", super_roles=".1.2.", female_name="Mestra", hidden=False,
        year_display_format=None,
    )
    make_role(".2.", "NEI", short="NEI")
    make_role(".2.1.", "Secreto", super_roles=".2.", hidden=True, icon="own.svg")


def _roles_of(user_id: int) -> list[dict]:
    return next(u for u in crud.get_multi() if u["_id"] == user_id)["user_roles"]


def test_listing_embeds_enriched_roles(org) -> None:
    make_user(1, "Ana Silva", sex="M")
    make_user_role(1, ".1.2.3.", 20)

    (role,) = _roles_of(1)

    assert role["org_name"] == "FAINA"  # first short found walking up
    assert role["role_name"] == "Mestre"
    assert role["parent_org_name"] == "Conselho"
    assert role["icon"] == "faina.svg"  # inherited from the ancestor
    assert role["year_display_format"] == "academic"  # inherited
    assert role["hidden"] is False
    assert isinstance(role["_id"], str)


def test_female_users_get_the_female_role_name(org) -> None:
    make_user(1, "Ana Silva", sex="F")
    make_user_role(1, ".1.2.3.", 20)

    assert _roles_of(1)[0]["role_name"] == "Mestra"


def test_own_icon_and_hidden_flag_are_not_inherited_from_parent(org) -> None:
    make_user(1, "Ana Silva")
    make_user_role(1, ".2.1.", 20)

    (role,) = _roles_of(1)

    assert role["icon"] == "own.svg"
    assert role["hidden"] is True
    assert role["org_name"] == "NEI"


def test_hidden_is_not_inherited_by_children() -> None:
    make_role(".1.", "Parent", hidden=True, short="P")
    make_role(".1.1.", "Child", super_roles=".1.")
    make_user(1, "A")
    make_user_role(1, ".1.1.", 20)

    assert _roles_of(1)[0]["hidden"] is False


def test_role_without_any_short_falls_back_to_role_name() -> None:
    make_role(".5.", "Sem Sigla")
    make_user(1, "A")
    make_user_role(1, ".5.", 20)

    (role,) = _roles_of(1)

    assert role["org_name"] == "Sem Sigla"
    assert role["year_display_format"] == "civil"
    assert role["icon"] is None


def test_assignment_pointing_to_unknown_role_does_not_break_listing() -> None:
    make_user(1, "A")
    make_user_role(1, ".9.9.", 20)

    (role,) = _roles_of(1)

    assert role["role_id"] == ".9.9."
    assert role["org_name"] is None
    assert role["hidden"] is False
    assert role["icon"] is None


def test_role_id_without_trailing_dot_is_normalised() -> None:
    org_map = crud._build_org_short_map() or {}
    make_role(".1.", "A", short="A")
    org_map = crud._build_org_short_map()

    assert crud._normalize_role_key(".1", org_map) == ".1."
    assert crud._normalize_role_key(".1.", org_map) == ".1."
    assert crud._normalize_role_key(".7.", org_map) == ".7."
    assert crud._normalize_role_key("", org_map) == ""


def test_enrich_role_with_empty_role_id_uses_defaults() -> None:
    role = {"role_id": ""}

    crud._enrich_role(role, {}, "M")

    assert role["year_display_format"] == "civil"
    assert role["icon"] is None
    assert role["hidden"] is False
    assert role["parent_org_name"] is None


def test_enrich_role_replaces_path_like_org_name() -> None:
    org_map = {".1.": {"short": "FAINA", "name": "Faina", "format": "civil"}}
    role = {"role_id": ".1.", "org_name": ".1."}

    crud._enrich_role(role, org_map, "M")

    assert role["org_name"] == "FAINA"


def test_enrich_role_keeps_human_readable_org_name() -> None:
    role = {"role_id": ".1.", "org_name": "Custom"}

    crud._enrich_role(role, {".1.": {"short": "X", "name": "x"}}, "M")

    assert role["org_name"] == "Custom"


def test_org_map_supports_integer_ids() -> None:
    from app.db.db import Role

    Role.insert_one({"_id": 13, "super_roles": ".1.7.", "name": "Num", "short": "N"})

    assert ".1.7.13." in crud._build_org_short_map()


def test_parent_name_helpers_handle_shallow_paths() -> None:
    org_map = {".1.": {"short": None, "name": "Root"}, ".1.2.": {"short": "S", "name": "n"}}

    assert crud._get_immediate_parent_name("", org_map) is None
    assert crud._get_immediate_parent_name(".1.", org_map) is None
    assert crud._get_immediate_parent_name(".1.2.", org_map) == "Root"  # short missing -> name
    assert crud._get_immediate_parent_name(".1.2.3.", org_map) == "S"
    assert crud._get_immediate_parent_name(".1.2.3.4.", org_map) is None  # parent unknown


def test_hidden_lookup_tolerates_missing_trailing_dot_and_none() -> None:
    org_map = {".1.": {"hidden": True}, ".2.": {"hidden": None}}

    assert crud._get_inherited_hidden(".1", org_map) is True
    assert crud._get_inherited_hidden(".2.", org_map) is False
    assert crud._get_inherited_hidden(".3.", org_map) is False
    assert crud._get_inherited_hidden("", org_map) is False


def test_roles_with_corrupt_data_are_skipped_not_fatal(monkeypatch) -> None:
    make_user(1, "A")
    make_user_role(1, ".1.", 20)
    monkeypatch.setattr(
        crud, "_enrich_role", MagicMock(side_effect=KeyError("boom"))
    )

    assert _ids(crud.get_multi()) == [1]


# -------------------------------------------------------------------------- tree


@pytest.fixture
def family() -> None:
    #   1 (18)
    #   |-- 2 (19) -- 4 (21)
    #   `-- 3 (20)
    #   5 (17) root, no children
    make_user(1, "Root A", start_year=18)
    make_user(2, "Child B", start_year=19, patrao_id=1)
    make_user(3, "Child C", start_year=20, patrao_id=1)
    make_user(4, "Grand D", start_year=21, patrao_id=2)
    make_user(5, "Root E", start_year=17)


def _shape(nodes) -> list:
    return [(n["_id"], _shape(n["children"])) for n in nodes]


def test_full_tree_nests_by_patrao_and_orders_roots_by_year(family) -> None:
    roots, total = crud.get_tree()

    assert total == 5
    assert _shape(roots) == [(5, []), (1, [(2, [(4, [])]), (3, [])])]


def test_tree_of_empty_database() -> None:
    assert crud.get_tree() == ([], 0)


def test_users_without_start_year_sort_last_among_roots() -> None:
    make_user(1, "A", start_year=None)
    make_user(2, "B", start_year=30)

    roots, _ = crud.get_tree()

    assert [n["_id"] for n in roots] == [2, 1]


def test_orphan_user_is_promoted_to_root(family) -> None:
    make_user(9, "Orphan", start_year=22, patrao_id=404)

    roots, total = crud.get_tree()

    assert 9 in [n["_id"] for n in roots]
    assert total == 6


def test_subtree_counts_only_returned_nodes(family) -> None:
    roots, total = crud.get_tree(root_id=2)

    assert _shape(roots) == [(2, [(4, [])])]
    assert total == 2


def test_unknown_subtree_root_returns_nothing(family) -> None:
    assert crud.get_tree(root_id=404) == ([], 0)


def test_depth_zero_returns_roots_flagged_as_having_more_children(family) -> None:
    roots, total = crud.get_tree(depth=0)

    by_id = {n["_id"]: n for n in roots}
    assert total == 2
    assert by_id[1]["children"] == []
    assert by_id[1]["has_more_children"] is True
    assert by_id[5]["has_more_children"] is False


def test_depth_one_includes_direct_children_only(family) -> None:
    roots, total = crud.get_tree(depth=1)

    root = next(n for n in roots if n["_id"] == 1)
    assert total == 4  # 5, 1, 2, 3
    assert [c["_id"] for c in root["children"]] == [2, 3]
    child_two = root["children"][0]
    assert child_two["children"] == []
    assert child_two["has_more_children"] is True
    assert root["children"][1]["has_more_children"] is False


def test_negative_depth_is_ignored(family) -> None:
    _, total = crud.get_tree(depth=-1)

    assert total == 5


def test_tree_nodes_carry_enriched_roles_with_hidden_flag(org) -> None:
    make_user(1, "Ana", start_year=18)
    make_user_role(1, ".2.1.", 20)

    roots, _ = crud.get_tree()

    (role,) = roots[0]["user_roles"]
    assert role["hidden"] is True
    assert role["org_name"] == "NEI"
    assert role["role_name"] == "Secreto"


# ------------------------------------------------------------------------ cycles


@pytest.mark.parametrize(
    "target,new_patrao,expected",
    [
        (1, None, False),  # becoming a root can never cycle
        (1, 1, True),  # self reference
        (1, 4, True),  # a descendant would become the patrão
        (2, 4, True),
        (4, 1, False),  # moving up the chain is fine
        (3, 2, False),  # sibling -> patrão is fine
        (3, 404, False),  # unknown patrão: nothing to traverse
    ],
)
def test_check_cycle(family, target, new_patrao, expected) -> None:
    assert crud.check_cycle(target, new_patrao) is expected


def test_check_cycle_stops_on_preexisting_loop() -> None:
    make_user(1, "A", patrao_id=2)
    make_user(2, "B", patrao_id=1)
    make_user(3, "C")

    assert crud.check_cycle(3, 1) is True


# ------------------------------------------------------------------------- image


def _png(size=(10, 10), mode="RGB") -> bytes:
    buf = BytesIO()
    Image.new(mode, size, "red").save(buf, format="PNG")
    return buf.getvalue()


@pytest.fixture
def storage(monkeypatch) -> MagicMock:
    mock = MagicMock()
    mock.upload_image.return_value = "https://cdn.test/family/users/1/x.jpg"
    monkeypatch.setattr(module, "storage_client", mock)
    return mock


def test_image_update_for_unknown_user_returns_none(storage) -> None:
    assert crud.update_image(404, _png()) is None
    storage.upload_image.assert_not_called()


def test_upload_converts_to_jpeg_stores_url_and_returns_updated_user(storage) -> None:
    make_user(1, "A")

    updated = crud.update_image(1, _png(mode="RGBA"))

    assert updated["image"] == "https://cdn.test/family/users/1/x.jpg"
    key, data, content_type = storage.upload_image.call_args.args
    assert key.startswith("family/users/1/")
    assert key.endswith(".jpg")
    assert content_type == "image/jpeg"
    assert Image.open(BytesIO(data)).format == "JPEG"


def test_large_images_are_downscaled_to_1200px(storage) -> None:
    make_user(1, "A")

    crud.update_image(1, _png(size=(3000, 2000)))

    data = storage.upload_image.call_args.args[1]
    assert max(Image.open(BytesIO(data)).size) <= 1200


def test_same_content_gets_the_same_storage_key(storage) -> None:
    make_user(1, "A")

    crud.update_image(1, _png())
    crud.update_image(1, _png())

    keys = [c.args[0] for c in storage.upload_image.call_args_list]
    assert keys[0] == keys[1]


def test_replacing_image_deletes_the_previous_one(storage) -> None:
    make_user(1, "A", image="https://cdn.test/old.jpg")

    crud.update_image(1, _png())

    storage.delete_image.assert_called_once_with("https://cdn.test/old.jpg")


def test_reuploading_identical_image_does_not_delete_it(storage) -> None:
    make_user(1, "A", image="https://cdn.test/family/users/1/x.jpg")

    crud.update_image(1, _png())

    storage.delete_image.assert_not_called()


def test_oversized_upload_is_rejected_before_any_processing(storage) -> None:
    make_user(1, "A")

    with pytest.raises(ValueError, match="under 2MB"):
        crud.update_image(1, b"0" * (2 * 1024 * 1024 + 1))

    storage.upload_image.assert_not_called()


def test_non_image_bytes_are_rejected(storage) -> None:
    make_user(1, "A")

    with pytest.raises(ValueError, match="Invalid image"):
        crud.update_image(1, b"definitely not an image")


def test_storage_failure_is_reported_and_user_unchanged(storage) -> None:
    make_user(1, "A", image="https://cdn.test/old.jpg")
    storage.upload_image.return_value = None

    image = _png()

    with pytest.raises(ValueError, match="Failed to upload"):
        crud.update_image(1, image)

    assert crud.get(1)["image"] == "https://cdn.test/old.jpg"
    storage.delete_image.assert_not_called()


def test_removing_image_deletes_remote_file_and_clears_field(storage) -> None:
    make_user(1, "A", image="https://cdn.test/old.jpg")

    updated = crud.update_image(1, None)

    assert updated["image"] is None
    storage.delete_image.assert_called_once_with("https://cdn.test/old.jpg")


def test_removing_when_there_is_no_image_is_a_noop_remotely(storage) -> None:
    make_user(1, "A")

    assert crud.update_image(1, None)["image"] is None
    storage.delete_image.assert_not_called()

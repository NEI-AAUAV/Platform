"""Role ids are materialised paths (`.1.5.`): generation, tree and lifecycle."""

from app.crud.crud_role import role as crud
from app.schemas.role import RoleCreate, RoleUpdate
from app.tests.factories import make_role


def _new(name: str, super_roles: str = "", **kw) -> RoleCreate:
    return RoleCreate(name=name, super_roles=super_roles, **kw)


# --------------------------------------------------------------- id generation


def test_first_root_role_is_dot_one() -> None:
    assert crud.create(obj_in=_new("Faina"))["_id"] == ".1."


def test_root_ids_increment_after_the_highest_existing_one() -> None:
    make_role(".1.", "A")
    make_role(".7.", "B")

    assert crud.create(obj_in=_new("C"))["_id"] == ".8."


def test_first_child_is_numbered_one_under_its_parent() -> None:
    make_role(".2.", "Parent")

    assert crud.create(obj_in=_new("Child", ".2."))["_id"] == ".2.1."


def test_children_use_max_sibling_plus_one_even_with_gaps() -> None:
    make_role(".2.", "Parent")
    make_role(".2.1.", "x", super_roles=".2.")
    make_role(".2.4.", "y", super_roles=".2.")

    assert crud.create(obj_in=_new("Child", ".2."))["_id"] == ".2.5."


def test_deep_children_are_numbered_within_their_own_parent() -> None:
    make_role(".1.", "A")
    make_role(".1.2.", "B", super_roles=".1.")
    make_role(".1.2.9.", "C", super_roles=".1.2.")

    assert crud.create(obj_in=_new("D", ".1.2."))["_id"] == ".1.2.10."


def test_created_role_keeps_all_fields() -> None:
    created = crud.create(
        obj_in=_new("Presidente", short="PRES", female_name="Presidenta", show=True, icon="i.png")
    )

    assert created["name"] == "Presidente"
    assert created["female_name"] == "Presidenta"
    assert created["show"] is True and created["icon"] == "i.png"
    assert created["year_display_format"] == "civil" and created["hidden"] is False


# --------------------------------------------------------------------- queries


def test_get_and_exists() -> None:
    make_role(".1.", "A")

    assert crud.get(".1.")["name"] == "A"
    assert crud.get(".9.") is None
    assert crud.exists(".1.") is True and crud.exists(".9.") is False


def test_listing_filters_by_visibility_and_parent_and_paginates() -> None:
    make_role(".1.", "A", show=True)
    make_role(".2.", "B")
    make_role(".1.1.", "A1", super_roles=".1.", show=True)
    make_role(".1.2.", "A2", super_roles=".1.")

    assert {r["_id"] for r in crud.get_multi(show_only=True)} == {".1.", ".1.1."}
    assert {r["_id"] for r in crud.get_multi(parent=".1.")} == {".1.1.", ".1.2."}
    assert {r["_id"] for r in crud.get_multi(parent="")} == {".1.", ".2."}
    assert len(crud.get_multi(limit=2)) == 2
    assert len(crud.get_multi(skip=3)) == 1
    assert crud.count() == 4


def test_get_children_returns_direct_children_only() -> None:
    make_role(".1.", "A")
    make_role(".1.1.", "B", super_roles=".1.")
    make_role(".1.1.1.", "C", super_roles=".1.1.")

    assert [r["_id"] for r in crud.get_children(".1.")] == [".1.1."]
    assert crud.get_children(".9.") == []


# ------------------------------------------------------------------------ tree


def test_tree_of_empty_collection_is_empty() -> None:
    assert crud.get_tree() == []


def test_tree_nests_children_under_parents() -> None:
    make_role(".1.", "Faina")
    make_role(".1.1.", "CF", super_roles=".1.")
    make_role(".1.1.1.", "MC", super_roles=".1.1.")
    make_role(".2.", "NEI")

    roots = crud.get_tree()

    assert [r["id"] for r in roots] == [".1.", ".2."]
    cf = roots[0]["children"][0]
    assert cf["id"] == ".1.1." and cf["children"][0]["id"] == ".1.1.1."
    assert roots[1]["children"] == []


def test_orphaned_role_is_promoted_to_root() -> None:
    make_role(".1.", "A")
    make_role(".9.1.", "Orphan", super_roles=".9.")

    assert {r["id"] for r in crud.get_tree()} == {".1.", ".9.1."}


# -------------------------------------------------------------------- mutation


def test_update_changes_given_fields_only() -> None:
    make_role(".1.", "Old", short="O")

    updated = crud.update(id=".1.", obj_in=RoleUpdate(name="New", hidden=True))

    assert (updated["name"], updated["short"], updated["hidden"]) == ("New", "O", True)


def test_empty_update_returns_role_and_unknown_returns_none() -> None:
    make_role(".1.", "A")

    assert crud.update(id=".1.", obj_in=RoleUpdate())["name"] == "A"
    assert crud.update(id=".9.", obj_in=RoleUpdate(name="x")) is None


def test_delete_reports_result() -> None:
    make_role(".1.", "A")

    assert crud.delete(id=".1.") is True
    assert crud.delete(id=".1.") is False

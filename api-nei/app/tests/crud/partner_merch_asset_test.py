"""Data-integrity tests for Partner/Merch's new Directus asset columns.

partner.header_asset/banner_asset and merch.image_asset were added by
alembic migration d7e9f1a3b5c7, onboarding these two content types into
Directus for the first time (previously they only had plain string URL
fields). Existing rows have no value for these new columns — they must
accept NULL without any migration/backfill required.
"""
from app.models.merch import Merch
from app.models.partner import Partner
from app.tests.conftest import SessionTesting


def test_partner_accepts_null_asset_columns(db: SessionTesting) -> None:
    partner = Partner(company="ACME", banner_until=None)
    db.add(partner)
    db.flush()

    db.refresh(partner)
    assert partner.header_asset is None
    assert partner.banner_asset is None


def test_partner_header_prefers_asset_over_legacy_string(db: SessionTesting) -> None:
    import uuid

    asset_id = uuid.uuid4()
    partner = Partner(company="ACME", header=None)
    partner._header = "/legacy-logo.png"
    partner.header_asset = asset_id
    db.add(partner)
    db.flush()

    assert str(asset_id) in partner.header


def test_merch_accepts_null_image_asset(db: SessionTesting) -> None:
    merch = Merch(name="T-shirt", discontinued=False)
    db.add(merch)
    db.flush()

    db.refresh(merch)
    assert merch.image_asset is None

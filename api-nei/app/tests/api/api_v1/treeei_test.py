import pytest
import os
from io import BytesIO

from fastapi.testclient import TestClient
from PIL import Image

from app.core.config import settings


test_image_id = "T0"
test_original_image_dir = "static/treeei/original/"
test_optimized_image_dir = "static/treeei/optimized/"


@pytest.fixture(autouse=True)
def run_around_tests():
    yield
    # Remove optimized test image created
    if os.path.exists(test_optimized_image_dir + test_image_id):
        os.remove(test_optimized_image_dir + test_image_id)

    # Remove original test image saved
    dir = os.listdir(test_original_image_dir)
    for file in dir:
        if file.startswith(test_image_id):
            os.remove(os.path.join(test_original_image_dir, file))


def test_create_treeei_node_with_png_image(client: TestClient) -> None:
    # Create a PNG test image
    image = Image.new('RGBA', size=(50, 50), color=(256, 0, 0))
    image_file = BytesIO()
    image.save(image_file, 'PNG')
    image_file.seek(0)

    data = {
        "id": test_image_id,
    }
    files = {
        "image": ('img.png', image_file, 'image/png'),
    }
    test_optimized_path = test_optimized_image_dir + test_image_id
    test_original_path = test_original_image_dir + test_image_id + ".png"

    r = client.post(f"{settings.API_V1_STR}/treeei/", files=files, data=data)
    data = r.json()
    assert data["id"] == test_image_id
    assert data["image"] == test_optimized_path
    assert os.path.exists(test_optimized_path)
    assert os.path.exists(test_original_path)

    optimized = Image.open(test_optimized_path)
    original = Image.open(test_original_path)

    assert optimized.width, optimized.height == (50, 50)
    assert original.width, original.height == (50, 50)


def test_create_treeei_node_with_jpeg_uncroped_image(client: TestClient) -> None:
    # Create a JPEG uncroped test image
    image = Image.new('RGB', size=(50, 100), color=(256, 0, 0))
    image_file = BytesIO()
    image.save(image_file, 'JPEG')
    image_file.seek(0)

    data = {
        "id": test_image_id,
    }
    files = {
        "image": ('img.JPG', image_file, 'image/jpeg'),
    }
    test_optimized_path = test_optimized_image_dir + test_image_id
    test_original_path = test_original_image_dir + test_image_id + ".jpeg"

    r = client.post(f"{settings.API_V1_STR}/treeei/", files=files, data=data)
    data = r.json()
    assert data["id"] == test_image_id
    assert data["image"] == test_optimized_path
    assert os.path.exists(test_optimized_path)
    assert os.path.exists(test_original_path)

    optimized = Image.open(test_optimized_path)
    original = Image.open(test_original_path)

    assert optimized.width, optimized.height == (50, 50)
    assert original.width, original.height == (50, 100)


def test_create_treeei_node_with_wrong_image_format(client: TestClient) -> None:
    # Create a TIFF test image
    image = Image.new('RGB', size=(50, 50), color=(256, 0, 0))
    image_file = BytesIO()
    image.save(image_file, 'TIFF')
    image_file.seek(0)

    data = {
        "id": test_image_id,
    }
    files = {
        "image": ('img.TIF', image_file, 'image/tiff'),
    }

    r = client.post(f"{settings.API_V1_STR}/treeei/", files=files, data=data)
    data = r.json()
    assert r.status_code == 406
    assert data["detail"] == "Image Format Not Acceptable"

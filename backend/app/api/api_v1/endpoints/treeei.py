from fastapi import APIRouter, File, UploadFile, Form, HTTPException
from fastapi.responses import JSONResponse
from typing import Any, List
from PIL import Image, ImageOps
import io


router = APIRouter()


@router.post("/", status_code=201)
async def create_treeei_node(
    *, id: str = Form(...), image: UploadFile = File(...)
) -> JSONResponse:
    img_data = await image.read()
    img = Image.open(io.BytesIO(img_data))
    ext = img.format
    if not ext in ('JPEG', 'PNG'):
        raise HTTPException(status_code=406, detail="Image format not acceptable")

    # handle EXIF orientation tag
    img = ImageOps.exif_transpose(img)

    # save original image on static folder
    img.save(f"static/treeei/original/{id}.{ext.lower()}")

    width, height = img.size

    # crop image to fit 1:1 ratio
    margin = abs(width - height) / 2
    if width > height:
        print((margin, 0, height, height))
        img = img.crop((margin, 0, margin + height, height))
    else:
        img = img.crop((0, margin, width, margin + width))

    # convert image mode to RGB to allow JPEG conversion
    img = img.convert("RGB")

    # resize image to 150x150 with the best quality resampling filter
    img = img.resize((150, 150), Image.LANCZOS)

    # quality parameter explained here:
    # https://github.com/python-pillow/Pillow/blob/main/src/PIL/JpegPresets.py

    # optimize and progressive flags explained here:
    # https://engineeringblog.yelp.com/2017/06/making-photos-smaller.html

    # save optimized image on static folder
    img.save(f"static/treeei/optimized/{id}",
                format="JPEG",
                quality="web_high",
                optimize=True,
                progressive=True)

    return {"filename": id}

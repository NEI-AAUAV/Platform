import os
from typing import Optional
import boto3
from botocore.config import Config
from loguru import logger
from app.core.config import settings


class StorageClient:
    def __init__(self):
        self.enabled = all([
            settings.R2_ENDPOINT_URL,
            settings.R2_ACCESS_KEY_ID,
            settings.R2_SECRET_ACCESS_KEY,
            settings.R2_BUCKET,
            settings.R2_PUBLIC_BASE_URL,
        ])
        if self.enabled:
            self.client = boto3.client(
                "s3",
                endpoint_url=settings.R2_ENDPOINT_URL,
                aws_access_key_id=settings.R2_ACCESS_KEY_ID,
                aws_secret_access_key=settings.R2_SECRET_ACCESS_KEY,
                config=Config(
                    signature_version="s3v4",
                    connect_timeout=10,
                    read_timeout=30,
                ),
            )
        else:
            self.client = None

    def upload_image(self, key: str, data: bytes, content_type: str) -> Optional[str]:
        """Upload image bytes to R2. Returns public URL or None if disabled."""
        if not self.enabled:
            logger.warning("R2 storage not configured; skipping upload")
            return None
        
        try:
            logger.info(f"Uploading image to R2: {key} ({len(data)} bytes)")
            self.client.put_object(
                Bucket=settings.R2_BUCKET,
                Key=key,
                Body=data,
                ContentType=content_type,
                ACL="public-read",
            )
            url = f"{settings.R2_PUBLIC_BASE_URL.rstrip('/')}/{key}"
            logger.info(f"Successfully uploaded to R2: {url}")
            return url
        except Exception as e:
            logger.error(f"Failed to upload to R2: {e}")
            return None


storage_client = StorageClient()

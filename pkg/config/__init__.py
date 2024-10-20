# Configuration management
from .config import Settings

__all__ = ["Settings"]

def get_settings():
    return Settings()
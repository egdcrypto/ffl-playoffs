"""
Application Settings

Uses Pydantic Settings for type-safe configuration management.
Settings are loaded from environment variables with sensible defaults.
"""
from pydantic_settings import BaseSettings
from functools import lru_cache


class NflSyncSettings(BaseSettings):
    """NFL Data Sync configuration"""
    enabled: bool = True
    interval_seconds: int = 60  # 1 minute polling during games
    offseason_interval_seconds: int = 3600  # 1 hour when no games

    # Cron schedules
    players_cron: str = "0 0 6 * * *"  # 6 AM daily
    schedules_cron: str = "0 0 0 * * MON"  # Monday at midnight

    # Rate limiting
    max_retries: int = 3
    retry_backoff_seconds: int = 15

    class Config:
        env_prefix = "NFL_SYNC_"


class RedisSettings(BaseSettings):
    """Redis configuration for delta detection"""
    url: str = "redis://localhost:6379"
    delta_ttl_seconds: int = 86400  # 24 hours

    class Config:
        env_prefix = "REDIS_"


class MongoSettings(BaseSettings):
    """MongoDB configuration"""
    url: str = "mongodb://localhost:27017"
    database: str = "ffl_playoffs"

    class Config:
        env_prefix = "MONGO_"


class ServerSettings(BaseSettings):
    """Server configuration"""
    host: str = "0.0.0.0"
    port: int = 8001
    debug: bool = False
    log_level: str = "INFO"

    class Config:
        env_prefix = "SERVER_"


class Settings(BaseSettings):
    """Main application settings"""
    nfl_sync: NflSyncSettings = NflSyncSettings()
    redis: RedisSettings = RedisSettings()
    mongo: MongoSettings = MongoSettings()
    server: ServerSettings = ServerSettings()

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


@lru_cache()
def get_settings() -> Settings:
    """Get cached settings instance"""
    return Settings()

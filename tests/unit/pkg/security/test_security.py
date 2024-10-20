import pytest
from datetime import timedelta
from jose import jwt, JWTError
from pkg.security.security import (
    verify_password,
    get_password_hash,
    create_access_token,
    decode_access_token
)
from pkg.config import Settings

TEST_PASSWORD = "test_password"

@pytest.fixture
def mock_settings(monkeypatch):
    def mock_get_settings():
        return Settings(
            SECRET_KEY="testsecretnolongsswksslkkslksss",
            ALGORITHM="HS256",
            ACCESS_TOKEN_EXPIRE_MINUTES=30
        )
    monkeypatch.setattr('pkg.security.security.get_settings', mock_get_settings)
    monkeypatch.setattr('pkg.config.get_settings', mock_get_settings)
    return mock_get_settings()

def test_verify_password():
    hashed_password = get_password_hash(TEST_PASSWORD)
    assert verify_password(TEST_PASSWORD, hashed_password) == True
    assert verify_password("wrong_password", hashed_password) == False

def test_get_password_hash():
    hashed_password = get_password_hash(TEST_PASSWORD)
    assert hashed_password != TEST_PASSWORD
    assert verify_password(TEST_PASSWORD, hashed_password) == True

def test_create_access_token(mock_settings):
    token = create_access_token({"sub": "test@example.com"})
    decoded = jwt.decode(token, mock_settings.SECRET_KEY, algorithms=[mock_settings.ALGORITHM])
    assert "sub" in decoded
    assert decoded["sub"] == "test@example.com"
    assert "exp" in decoded

    custom_expires = timedelta(hours=1)
    token = create_access_token({"sub": "test@example.com"}, custom_expires)
    decoded = jwt.decode(token, mock_settings.SECRET_KEY, algorithms=[mock_settings.ALGORITHM])
    assert "exp" in decoded

def test_decode_access_token(mock_settings):
    token_data = {"sub": "test@example.com"}
    token = create_access_token(token_data)
    
    decoded = decode_access_token(token)
    assert decoded["sub"] == token_data["sub"]

    with pytest.raises(JWTError):
        decode_access_token("invalid_token")
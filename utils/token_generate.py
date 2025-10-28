import secrets


def generate_token(length: int = 15) -> str:
    """Generate a secure random token."""
    return secrets.token_urlsafe(length)

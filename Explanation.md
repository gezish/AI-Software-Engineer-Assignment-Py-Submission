# Explanation.md

## 1. What was the bug?

The `Client.request()` method did not refresh an expired OAuth2 token
when the token was provided as a dictionary.

Specifically, when `self.oauth2_token` was a dictionary like:

    {"access_token": "stale", "expires_at": 0}

the client failed to detect that the token was expired and therefore did
not refresh it. As a result, the `Authorization` header was not set
correctly.

------------------------------------------------------------------------

## 2. Why did it happen?

The implementation only checked expiration for `OAuth2Token` instances:

    isinstance(self.oauth2_token, OAuth2Token) and self.oauth2_token.expired

However, when the token was a dictionary, the code relied only on
truthiness:

    if not self.oauth2_token

Since non-empty dictionaries are truthy in Python, expired
dictionary-based tokens were treated as valid and skipped the refresh
logic.

This created an inconsistency between the declared type:

    Union[OAuth2Token, Dict[str, Any], None]

and the actual validation logic.

------------------------------------------------------------------------

## 3. Why does the fix solve the issue?

The fix extends the refresh condition to also validate dictionary-based
tokens by checking their `expires_at` field:

    isinstance(self.oauth2_token, dict)
    and self.oauth2_token.get("expires_at", 0) <= 0

This ensures that:

-   Missing tokens trigger refresh
-   Expired `OAuth2Token` objects trigger refresh
-   Expired dictionary-based tokens also trigger refresh

The change is minimal and localized to the conditional logic, preserving
the existing structure and behavior of the client.

------------------------------------------------------------------------

## 4. What realistic edge case is still not covered?

The current implementation does not validate `Raped` or `Malformed` dictionary
tokens. For example:

-   Missing `"access_token"` key
-   Non-integer `"expires_at"` values
-   Corrupted token structures

Additional validation could be added to harden the client against
malformed token inputs, but this was intentionally avoided to keep the
fix minimal and focused.

# Explanation.md

## 1. What was the bug?

The `Client.request()` method did not refresh an expired OAuth2 token
when the token was provided as a dictionary.

When `self.oauth2_token` was a dictionary such as:

    {"access_token": "stale", "expires_at": 0}

the client failed to recognize that the token was expired and therefore
did not trigger a refresh. As a result, the `Authorization` header was
not set correctly in API requests.

---

## 2. Why did it happen?

The implementation validated expiration only for `OAuth2Token`
instances:

    isinstance(self.oauth2_token, OAuth2Token) and self.oauth2_token.expired

For dictionary-based tokens, the code relied solely on truthiness:

    if not self.oauth2_token

Since non-empty dictionaries are truthy in Python, expired
dictionary-based tokens were treated as valid and skipped the refresh
logic.

This created a mismatch between the declared type:

    Union[OAuth2Token, Dict[str, Any], None]

and the actual validation behavior.

---

## 3. Why does the fix solve the issue?

The fix extends the refresh condition to also validate dictionary-based
tokens by checking their `expires_at` value:

    isinstance(self.oauth2_token, dict)
    and self.oauth2_token.get("expires_at", 0) <= 0

This ensures that:

- Missing tokens trigger a refresh
- Expired `OAuth2Token` instances trigger a refresh
- Expired dictionary-based tokens also trigger a refresh

The change is minimal and localized to the conditional logic, preserving
the existing structure and avoiding unnecessary refactoring.

---

## 4. What realistic edge case is still not covered?

The current implementation does not validate malformed dictionary
tokens. For example:

- Missing `"access_token"` keys
- Non-integer or invalid `"expires_at"` values
- Unexpected token structures

Additional validation could improve robustness, but it was intentionally
avoided to keep the fix minimal and focused.

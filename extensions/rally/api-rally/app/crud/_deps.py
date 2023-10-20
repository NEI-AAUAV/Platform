import re


def unique_key_error_regex(column: str) -> re.Pattern:
    return re.compile(f"Key \\({re.escape(column)}\\)=\\([^\\)]*\\) already exists")


def foreign_key_error_regex(column: str) -> re.Pattern:
    return re.compile(
        f"Key \\({re.escape(column)}\\)=\\([^\\)]*\\) is not present in table"
    )

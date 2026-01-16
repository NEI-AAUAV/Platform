"""
Application-wide constants for the Family API.
Centralizes magic numbers and default values.
"""

# Sorting defaults
INFINITY_SORT_VALUE = 9999  # Value for null years to sort at end
DEFAULT_SORT_FIELD = "name"
DEFAULT_SORT_ORDER = "asc"

# Pagination defaults  
DEFAULT_SKIP = 0
DEFAULT_LIMIT = 100
MAX_LIMIT = 500

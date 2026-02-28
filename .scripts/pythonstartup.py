"""Startup file for Python REPL"""

import atexit
import json
import os

from datetime import datetime, date, timedelta
from pprint import pprint

try:
    import requests
except ImportError:
    pass

try:
    import asyncio
except ImportError:
    pass

try:
    # Will only work on Linux; readline is not intended for Windows
    import readline

    readline.parse_and_bind("tab: complete")
    print("readline support")
    del readline
except ImportError:
    print("no readline support.")

VENV = os.environ.get("VIRTUAL_ENV")
print(VENV)

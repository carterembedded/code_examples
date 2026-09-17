# Trying out the urllib retrive/retrieval method
import os
from urllib.request import urlretrieve

# This downloads a file
FILENAME = "secure_keys.tgz"
URL = (
        "https://api.media.atlassian.com/file/FILE_UUID/binary"
        "?token=A_TOKEN&"
        f"client=CLIENT_UUID&dl=true&name={FILENAME}"
        )
urlretrieve(URL, FILENAME)

# If nothing changes, it will request the SAME file but just give it a new name.
FILENAME = "test_keys.tar.gz"
URL = (
        "https://api.media.atlassian.com/file/FILE_UUID/binary"
        "?token=A_TOKEN&"
        f"client=CLIENT_UUID&dl=true&name={FILENAME}"
        )
urlretrieve(URL, FILENAME)

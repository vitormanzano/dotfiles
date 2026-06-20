#!/usr/bin/env python3
import subprocess
import json
import sys

def run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else ""

status = run(["playerctl", "-p", "spotify", "status"])
if not status:
    print("")
    sys.exit(0)

artist = run(["playerctl", "-p", "spotify", "metadata", "artist"])
title = run(["playerctl", "-p", "spotify", "metadata", "title"])

icon = " " if status == "Playing" else " "
text = f"{icon}{artist} - {title}" if artist and title else f"{icon}{title}"

print(json.dumps({"text": text, "alt": status.lower(), "class": "custom-spotify"}))

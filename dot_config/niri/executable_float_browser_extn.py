#!/usr/bin/env python3

import json
import re
import subprocess
import time


# config
RULES = [
    {
        "pattern": re.compile(r"Extension: .* Mozilla Firefox"),
        "width": "20%",
        "height": "50%",
    },
    {
        "pattern": re.compile(r"Extension: .* Zen Browser"),
        "width": "25%",
        "height": "55%",
    },
    {
        "pattern": re.compile(r"Extension: .* LibreWolf"),
        "width": "20%",
        "height": "50%",
    },
    {
        "pattern": re.compile(r"Bitwarden"),
        "width": "30%",
        "height": "60%",
    },
]


handled = set()


def niri(*args):
    subprocess.run(
        ["niri", "msg", *args],
        check=True,
    )


def handle_window(window):
    window_id = window["id"]
    title = window.get("title")

    # Skip windows without a title or windows that are already floating
    if not title or window.get("is_floating"):
        return

    # skip if already handled
    if window_id in handled:
        return

    # check for each rule
    for rule in RULES:
        if not rule["pattern"].search(title):
            continue

        handled.add(window_id)

        # float
        niri(
            "action",
            "toggle-window-floating",
            f"--id={window_id}",
        )

        # let window settle a bit
        time.sleep(0.15)

        # resize
        niri(
            "action",
            "set-window-width",
            rule["width"],
            f"--id={window_id}",
        )
        niri(
            "action",
            "set-window-height",
            rule["height"],
            f"--id={window_id}",
        )

        # let window settle a bit
        time.sleep(0.15)

        # center
        niri(
            "action",
            "center-window",
            f"--id={window_id}",
        )

        # let window settle a bit
        time.sleep(0.15)

        # recenter as sometimes the window is a bit off center
        # TODO: find a better fix?
        niri(
            "action",
            "center-window",
            f"--id={window_id}",
        )

        break


def main():
    # main event listener loop
    stream = subprocess.Popen(
        ["niri", "msg", "-j", "event-stream"],
        stdout=subprocess.PIPE,
        text=True,
        bufsize=1,
    )

    for line in stream.stdout:
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue

        event = event.get("WindowOpenedOrChanged")
        if not event:
            continue

        window = event.get("window")
        if window:
            handle_window(window)


if __name__ == "__main__":
    main()

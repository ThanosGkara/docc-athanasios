#!/usr/bin/env python3

"""Flatten config..."""

import collections
import json
# import re
import sys
import yaml


def filter_ranches(config):
    """Returns the input dict with noncompliant ranches expunged"""

    approved_ranches = {
        k: v for (k, v) in config["foo"]["ranches"].items()
        if v.get("cows", 0) >= 2 and v.get("hectares", 0) >= 4
    }

    config["foo"]["ranches"] = approved_ranches
    return config


def flatten(d, parent_key="", sep="."):
    # https://stackoverflow.com/a/6027615
    items = []
    for k, v in d.items():
        new_key = parent_key + sep + k if parent_key else k
        if isinstance(v, collections.abc.MutableMapping):
            items.extend(flatten(v, new_key, sep=sep).items())
        else:
            items.append((new_key, v))
    return dict(items)


def new_vocab(s):
    # First check fo the the bigger word clientele and then client
    # Did this to avoid passing big files more than once ( probably not the best implementation)
    return s.replace('clientele', 'fans').replace('client', 'visitor')


def main():
    """Exec as a script"""

    loaded = yaml.safe_load(sys.stdin)
    flat = flatten(filter_ranches(loaded))
    clean_string = new_vocab(json.dumps(flat))
    print(clean_string)


if __name__ == "__main__":
    sys.exit(main())

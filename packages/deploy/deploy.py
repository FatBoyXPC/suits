#!/usr/bin/env python3

import argparse
import dataclasses
import socket
import subprocess
from pathlib import Path
from typing import Literal, cast, get_args


def run(command: list[str]) -> None:
    subprocess.run(command, check=True)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--debug', action = "store_true")
    parser.add_argument('target', nargs = '?', default = socket.gethostname())
    args = parser.parse_args()

    target = args.target
    fleet = get_fleet()
    if target not in fleet:
        print(f"The target must be one of: {', '.join(sorted(fleet.keys()))}.")
        return 1

    hostname = socket.gethostname()

    rebuild_command = []

    if target == hostname:
        rebuild_command.extend(["sudo"])

    rebuild_command.extend ([
        f"{fleet[target].type}-rebuild",
        "switch",
        "--flake",
        f".#{target}",
    ])

    build_host = "paulson"
    if target != hostname:
        if fleet[target].type != fleet[build_host].type:
            print("Do not try to remote build different OS types.")
            return 1

        rebuild_command.extend([
            "--sudo",
            "--target-host",
            target,
            "--build-host",
            build_host,
            "--use-substitutes"
        ])

    if args.debug:
        print(" ".join(rebuild_command))
        return 0

    if Path("encrypted-secrets", target).is_dir():
        run(["decrypt"])
        run(
            [
                "rsync",
                "-avP",
                "--delete",
                "--chown=root:root",
                "--rsync-path=sudo rsync",
                f"decrypted-secrets/{target}/",
                f"{target}:/etc/secrets/",
            ]
        )

    run(rebuild_command)
    return 0

OsType = Literal['darwin', 'nixos']

@dataclasses.dataclass
class FleetMember:
    name: str
    type: OsType

def get_fleet() -> dict[str, FleetMember]:
    return {
        p.name: FleetMember(name = p.name, type = parse_type(p.parent.name))
        for p in Path("fleet").glob("*/*")
        if p.name not in {"pearson"}
    }


def parse_type(os_type: str) -> OsType:
    if os_type not in get_args(OsType):
        raise ValueError(f"Invalid OS type: {os_type!r}")

    return cast(OsType, os_type)

if __name__ == "__main__":
    raise SystemExit(main())

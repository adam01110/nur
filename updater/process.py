from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]


class CommandError(RuntimeError):
    def __init__(self, command: list[str], result: subprocess.CompletedProcess[str]) -> None:
        self.command = command
        self.result = result
        super().__init__(result.stderr.strip() or result.stdout.strip() or "command failed")


def run(
    command: list[str],
    *,
    check: bool = True,
    timeout: str | None = None,
    cwd: Path = ROOT,
) -> subprocess.CompletedProcess[str]:
    env = os.environ.copy()
    actual = command
    if timeout and timeout != "0":
        actual = ["timeout", "--foreground", timeout, *command]

    result = subprocess.run(
        actual,
        cwd=cwd,
        env=env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if check and result.returncode != 0:
        raise CommandError(actual, result)
    return result


def run_json(command: list[str], **kwargs: Any) -> Any:
    return json.loads(run(command, **kwargs).stdout)

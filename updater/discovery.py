from __future__ import annotations

from collections.abc import Iterable

from .models import PackageRef, SourceKind
from .nix import attr_file_path, flake_attrsets, list_derivations, list_file_attrsets


def discover_packages(system: str) -> list[PackageRef]:
    refs: list[PackageRef] = []
    for attrset in flake_attrsets(system):
        refs.extend(_refs_for_attrset("flake", attrset))
    for attrset in list_file_attrsets():
        refs.extend(_refs_for_attrset("file", attrset))
    return refs


def filter_packages(refs: Iterable[PackageRef], selected: list[str]) -> list[PackageRef]:
    if not selected:
        return list(refs)
    wanted = set(selected)
    return [ref for ref in refs if ref.attr_path in wanted or ref.attr in wanted]


def _refs_for_attrset(source_kind: SourceKind, attrset: str) -> list[PackageRef]:
    refs: list[PackageRef] = []
    for attr in list_derivations(source_kind, attrset):
        file_path = attr_file_path(source_kind, attrset, attr)
        if not file_path:
            continue
        refs.append(
            PackageRef(
                source_kind=source_kind,
                attrset=attrset,
                attr=attr,
                attr_path=f"{attrset}.{attr}",
                file_path=file_path,
            )
        )
    return refs

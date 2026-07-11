#!/usr/bin/env python3
"""Check and update manually tracked pins in this flake.

The updater is intentionally conservative: deterministic `apply` updates only
entries marked `auto`. Review-required entries can be applied one at a time with
`--entry NAME --reviewed`; report-only entries are never modified by this tool.
"""

from __future__ import annotations

import argparse
import dataclasses
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
USER_AGENT = "suderpkgs-update-pins/1.0"
PIN_FILES = {
    "chromium": "pins/chromium.nix",
    "containers": "pins/containers.nix",
    "fetchurl": "pins/fetchurl.nix",
    "firefox": "pins/firefox.nix",
    "github": "pins/github.nix",
}


class UpdateError(RuntimeError):
    pass


@dataclasses.dataclass(frozen=True)
class Entry:
    name: str
    group: str
    pin_name: str
    value_field: str
    kind: str
    policy: str
    checker: str
    validate: tuple[str, ...]
    params: dict[str, Any] = dataclasses.field(default_factory=dict)

    @property
    def file(self) -> str:
        return PIN_FILES[self.group]


@dataclasses.dataclass
class Candidate:
    value: str | None
    fields: dict[str, str] = dataclasses.field(default_factory=dict)
    source: str | None = None
    reason: str | None = None


@dataclasses.dataclass
class Result:
    name: str
    kind: str
    policy: str
    file: str
    current: str | None
    candidate: str | None
    action: str
    reason: str
    fields: dict[str, str] = dataclasses.field(default_factory=dict)
    validation: list[str] = dataclasses.field(default_factory=list)


ENTRIES: tuple[Entry, ...] = (
    Entry(
        name="citron",
        group="fetchurl",
        pin_name="citron",
        value_field="version",
        kind="fetchurl-release",
        policy="auto",
        checker="citron-nightly",
        validate=("nix eval .#pins.fetchurl.citron.url",),
    ),
    Entry(
        name="eden",
        group="fetchurl",
        pin_name="eden",
        value_field="version",
        kind="fetchurl-release",
        policy="review",
        checker="unsupported",
        validate=("nix eval .#pins.fetchurl.eden.url",),
        params={"reason": "RC-versus-stable policy requires human or agent review."},
    ),
    Entry(
        name="honcho",
        group="github",
        pin_name="honcho",
        value_field="rev",
        kind="fetch-github-rev",
        policy="auto",
        checker="github-release",
        validate=("nix eval .#pins.github.honcho.rev",),
        params={"owner": "plastic-labs", "repo": "honcho", "strip_v": False},
    ),
    Entry(
        name="mpd-url",
        group="github",
        pin_name="mpd-url",
        value_field="rev",
        kind="fetch-github-rev",
        policy="review",
        checker="github-default-branch",
        validate=("nix eval .#pins.github.mpd-url.rev",),
        params={"owner": "suderman", "repo": "mpd-url"},
    ),
    Entry(
        name="easy-container-shortcuts",
        group="firefox",
        pin_name="easy-container-shortcuts",
        value_field="version",
        kind="firefox-xpi",
        policy="auto",
        checker="amo-addon",
        validate=("nix eval .#pins.firefox.easy-container-shortcuts.url",),
        params={"slug": "easy-container-shortcuts"},
    ),
    Entry(
        name="chromium-web-store",
        group="chromium",
        pin_name="chromium-web-store",
        value_field="version",
        kind="manual-version",
        policy="auto",
        checker="github-release",
        validate=("nix eval .#pins.chromium.chromium-web-store.url",),
        params={"owner": "NeverDecaf", "repo": "chromium-web-store", "strip_v": True},
    ),
    Entry(
        name="backblaze-personal-wine",
        group="containers",
        pin_name="backblaze-personal-wine",
        value_field="version",
        kind="container-tag",
        policy="report",
        checker="dockerhub-semver",
        validate=("nix eval .#pins.containers.backblaze-personal-wine.image",),
        params={"namespace": "tessypowder", "repo": "backblaze-personal-wine", "strip_v": True},
    ),
    Entry(
        name="codex-lb",
        group="containers",
        pin_name="codex-lb",
        value_field="version",
        kind="container-tag",
        policy="review",
        checker="github-container",
        validate=("nix eval .#pins.containers.codex-lb.image",),
        params={"owner_kind": "users", "owner": "Soju06", "package": "codex-lb", "strip_v": False},
    ),
    Entry(
        name="home-assistant",
        group="containers",
        pin_name="home-assistant",
        value_field="version",
        kind="container-tag",
        policy="auto",
        checker="github-release",
        validate=("nix eval .#pins.containers.home-assistant.image",),
        params={"owner": "home-assistant", "repo": "core", "strip_v": False},
    ),
    Entry(
        name="immich",
        group="containers",
        pin_name="immich",
        value_field="version",
        kind="manual-version",
        policy="auto",
        checker="github-release",
        validate=("nix eval .#pins.containers.immich.serverImage",),
        params={"owner": "immich-app", "repo": "immich", "strip_v": True},
    ),
    Entry(
        name="rsshub",
        group="containers",
        pin_name="rsshub",
        value_field="tag",
        kind="container-tag",
        policy="report",
        checker="unsupported",
        validate=("nix eval .#pins.containers.rsshub.image",),
        params={"reason": "chromium-bundled is an intentionally preserved flavor tag."},
    ),
    Entry(
        name="rsshub-redis",
        group="containers",
        pin_name="rsshub-redis",
        value_field="tag",
        kind="container-tag",
        policy="auto",
        checker="dockerhub-semver",
        validate=("nix eval .#pins.containers.rsshub-redis.image",),
        params={
            "namespace": "library",
            "repo": "redis",
            "full_patch": True,
            "same_major_minor": True,
        },
    ),
    Entry(
        name="unifi",
        group="containers",
        pin_name="unifi",
        value_field="version",
        kind="container-tag",
        policy="report",
        checker="dockerhub-semver",
        validate=("nix eval .#pins.containers.unifi.image",),
        params={"namespace": "jacobalberty", "repo": "unifi", "strip_v": True},
    ),
    Entry(
        name="whoami",
        group="containers",
        pin_name="whoami",
        value_field="version",
        kind="container-tag",
        policy="auto",
        checker="dockerhub-semver",
        validate=("nix eval .#pins.containers.whoami.image",),
        params={
            "namespace": "traefik",
            "repo": "whoami",
            "strip_v": True,
            "full_patch": True,
            "ignore_arch": True,
        },
    ),
    Entry(
        name="whoogle-search",
        group="containers",
        pin_name="whoogle-search",
        value_field="version",
        kind="container-tag",
        policy="auto",
        checker="github-release",
        validate=("nix eval .#pins.containers.whoogle-search.image",),
        params={"owner": "benbusby", "repo": "whoogle-search", "strip_v": True},
    ),
    Entry(
        name="zwave-js-ui",
        group="containers",
        pin_name="zwave-js-ui",
        value_field="version",
        kind="container-tag",
        policy="auto",
        checker="github-release",
        validate=("nix eval .#pins.containers.zwave-js-ui.image",),
        params={"owner": "zwave-js", "repo": "zwave-js-ui", "strip_v": True},
    ),
)

ENTRY_BY_NAME = {entry.name: entry for entry in ENTRIES}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    check_parser = subparsers.add_parser("check", help="query upstreams and report candidates")
    add_selection_args(check_parser)
    add_report_args(check_parser)

    report_parser = subparsers.add_parser("report", help="alias for check with markdown output")
    add_selection_args(report_parser)
    add_report_args(report_parser)
    report_parser.set_defaults(format="markdown")

    apply_parser = subparsers.add_parser("apply", help="apply deterministic updates")
    add_selection_args(apply_parser)
    add_report_args(apply_parser)
    apply_parser.add_argument("--safe", action="store_true", help="accepted for readability; apply is auto-only by default")
    apply_parser.add_argument("--reviewed", action="store_true", help="allow selected review-required entries")
    apply_parser.add_argument("--validate", action="store_true", help="run validation after edits")
    apply_parser.add_argument("--flake-check", action="store_true", help="include nix flake check --no-build during validation")
    apply_parser.add_argument("--commit", action="store_true", help="commit changed pin files after validation")
    apply_parser.add_argument("--push", action="store_true", help="push after committing")

    validate_parser = subparsers.add_parser("validate", help="run validation commands")
    add_selection_args(validate_parser)
    validate_parser.add_argument("--flake-check", action="store_true", help="include nix flake check --no-build")

    commit_parser = subparsers.add_parser("commit", help="commit changed pin files")
    commit_parser.add_argument("--push", action="store_true", help="push after committing")
    commit_parser.add_argument("--message", default="chore: update manual dependency pins")

    args = parser.parse_args()
    try:
        if args.command in {"check", "report"}:
            entries = select_entries(args.entry)
            pins = load_pins()
            results = evaluate_entries(entries, pins)
            write_reports(results, args)
            return 0 if all(result.action != "failed" for result in results) else 1

        if args.command == "apply":
            entries = select_entries(args.entry)
            pins = load_pins()
            results = apply_entries(entries, pins, reviewed=args.reviewed, selected=bool(args.entry))
            write_reports(results, args)
            changed = [result.name for result in results if result.action == "updated"]
            if changed and args.validate:
                validate_entries(select_entries(changed), flake_check=args.flake_check)
            if args.push and not args.commit:
                raise UpdateError("--push requires --commit")
            if args.commit:
                if changed:
                    commit_changed_pin_files(push=args.push)
                else:
                    print("no updates to commit")
            return 0 if all(result.action != "failed" for result in results) else 1

        if args.command == "validate":
            entries = select_entries(args.entry) if args.entry else changed_entries_from_git()
            if not entries:
                entries = ()
            validate_entries(entries, flake_check=args.flake_check)
            return 0

        if args.command == "commit":
            commit_changed_pin_files(push=args.push, message=args.message)
            return 0

        raise UpdateError(f"unhandled command: {args.command}")
    except UpdateError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


def add_selection_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--entry", action="append", help="limit to one entry; may be repeated")


def add_report_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--format", choices=("human", "markdown", "json"), default="human")
    parser.add_argument("--write-json", help="write JSON report to this path")
    parser.add_argument("--write-markdown", help="write Markdown report to this path")


def select_entries(names: list[str] | None) -> tuple[Entry, ...]:
    if not names:
        return ENTRIES
    selected = []
    for name in names:
        try:
            selected.append(ENTRY_BY_NAME[name])
        except KeyError as error:
            valid = ", ".join(sorted(ENTRY_BY_NAME))
            raise UpdateError(f"unknown entry {name!r}; valid entries: {valid}") from error
    return tuple(selected)


def load_pins() -> dict[str, Any]:
    completed = run(["nix", "eval", "--json", ".#pins"], capture=True)
    return json.loads(completed.stdout)


def evaluate_entries(entries: tuple[Entry, ...], pins: dict[str, Any]) -> list[Result]:
    return [evaluate_entry(entry, pins) for entry in entries]


def evaluate_entry(entry: Entry, pins: dict[str, Any]) -> Result:
    current_pin = pins[entry.group][entry.pin_name]
    current = str(current_pin[entry.value_field])
    try:
        candidate = find_candidate(entry, current, current_pin)
    except Exception as error:  # noqa: BLE001 - report per-entry failures and continue.
        return Result(
            name=entry.name,
            kind=entry.kind,
            policy=entry.policy,
            file=entry.file,
            current=current,
            candidate=None,
            action="failed",
            reason=str(error),
        )

    if candidate.value is None:
        return Result(
            name=entry.name,
            kind=entry.kind,
            policy=entry.policy,
            file=entry.file,
            current=current,
            candidate=None,
            action="skipped-review-required" if entry.policy == "review" else "skipped-report-only" if entry.policy == "report" else "unsupported",
            reason=candidate.reason or "no deterministic candidate available",
        )

    if candidate_is_downgrade(current, candidate.value):
        return Result(
            name=entry.name,
            kind=entry.kind,
            policy=entry.policy,
            file=entry.file,
            current=current,
            candidate=candidate.value,
            action="current-newer",
            reason="current pin is newer than the upstream candidate; refusing to downgrade",
            fields=candidate.fields,
        )

    changed_fields = candidate_changed_fields(entry, current_pin, candidate)
    if not changed_fields:
        return Result(
            name=entry.name,
            kind=entry.kind,
            policy=entry.policy,
            file=entry.file,
            current=current,
            candidate=candidate.value,
            action="up-to-date",
            reason=candidate.reason or "current pin matches upstream candidate",
            fields={},
        )

    if entry.policy == "report":
        action = "skipped-report-only"
        reason = "newer candidate found, but this entry is report-only"
    elif entry.policy == "review":
        action = "skipped-review-required"
        reason = "newer candidate found, but this entry requires review"
    else:
        action = "update-available"
        reason = candidate.reason or "newer candidate found"

    return Result(
        name=entry.name,
        kind=entry.kind,
        policy=entry.policy,
        file=entry.file,
        current=current,
        candidate=candidate.value,
        action=action,
        reason=reason,
        fields=changed_fields,
    )


def apply_entries(
    entries: tuple[Entry, ...],
    pins: dict[str, Any],
    *,
    reviewed: bool,
    selected: bool,
) -> list[Result]:
    results = []
    for entry in entries:
        result = evaluate_entry(entry, pins)
        if result.action != "update-available":
            if result.action == "skipped-review-required" and reviewed and selected:
                pass
            else:
                results.append(result)
                continue

        if entry.policy == "report":
            results.append(result)
            continue
        if entry.policy == "review" and not (reviewed and selected):
            results.append(result)
            continue

        current_pin = pins[entry.group][entry.pin_name]
        current = str(current_pin[entry.value_field])
        try:
            candidate = find_candidate(entry, current, current_pin)
            if candidate.value is None:
                results.append(result)
                continue
            fields = candidate_changed_fields(entry, current_pin, candidate)
            if not fields:
                results.append(result)
                continue
            fields = refresh_hash_fields(entry, fields)
            replace_pin_fields(ROOT / entry.file, entry.pin_name, fields)
            results.append(
                Result(
                    name=entry.name,
                    kind=entry.kind,
                    policy=entry.policy,
                    file=entry.file,
                    current=current,
                    candidate=candidate.value,
                    action="updated",
                    reason="updated pin file",
                    fields=fields,
                )
            )
            pins[entry.group][entry.pin_name].update(fields)
        except Exception as error:  # noqa: BLE001 - keep processing independent entries.
            results.append(
                Result(
                    name=entry.name,
                    kind=entry.kind,
                    policy=entry.policy,
                    file=entry.file,
                    current=current,
                    candidate=result.candidate,
                    action="failed",
                    reason=str(error),
                )
            )
    return results


def candidate_changed_fields(entry: Entry, current_pin: dict[str, Any], candidate: Candidate) -> dict[str, str]:
    fields = {entry.value_field: candidate.value} if candidate.value is not None else {}
    fields.update(candidate.fields)
    return {
        key: value
        for key, value in fields.items()
        if value is not None and str(current_pin.get(key)) != str(value)
    }


def find_candidate(entry: Entry, current: str, current_pin: dict[str, Any]) -> Candidate:
    checker = entry.checker
    if checker == "unsupported":
        return Candidate(value=None, reason=entry.params.get("reason"))
    if checker == "github-release":
        return github_release_candidate(entry, current)
    if checker == "github-default-branch":
        return github_default_branch_candidate(entry)
    if checker == "github-container":
        return github_container_candidate(entry, current)
    if checker == "dockerhub-semver":
        return dockerhub_semver_candidate(entry, current)
    if checker == "citron-nightly":
        return citron_nightly_candidate()
    if checker == "amo-addon":
        return amo_addon_candidate(entry, current_pin)
    raise UpdateError(f"unknown checker {checker!r} for {entry.name}")


def github_release_candidate(entry: Entry, current: str) -> Candidate:
    owner = entry.params["owner"]
    repo = entry.params["repo"]
    strip_v = bool(entry.params.get("strip_v", True))
    releases = http_json(f"https://api.github.com/repos/{owner}/{repo}/releases?per_page=100")
    candidates = []
    for release in releases:
        if release.get("draft") or release.get("prerelease"):
            continue
        tag = str(release.get("tag_name", ""))
        key = numeric_version_key(tag)
        if not key:
            continue
        value = strip_leading_v(tag) if strip_v else tag
        candidates.append((key, value, tag))
    if not candidates:
        candidates = github_tag_candidates(owner, repo, strip_v=strip_v)
    if not candidates:
        return Candidate(value=None, reason=f"no stable numeric GitHub releases or tags found for {owner}/{repo}")
    _key, value, tag = max(candidates, key=lambda item: item[0])
    reason = "current pin matches latest stable GitHub release" if value == current else f"latest stable GitHub release is {tag}"
    return Candidate(value=value, source=f"https://github.com/{owner}/{repo}/releases", reason=reason)


def github_tag_candidates(owner: str, repo: str, *, strip_v: bool) -> list[tuple[tuple[int, ...], str, str]]:
    tags = http_json(f"https://api.github.com/repos/{owner}/{repo}/tags?per_page=100")
    candidates = []
    for tag_info in tags:
        tag = str(tag_info.get("name", ""))
        key = numeric_version_key(tag)
        if not key:
            continue
        value = strip_leading_v(tag) if strip_v else tag
        candidates.append((key, value, tag))
    return candidates


def github_default_branch_candidate(entry: Entry) -> Candidate:
    owner = entry.params["owner"]
    repo = entry.params["repo"]
    repo_data = http_json(f"https://api.github.com/repos/{owner}/{repo}")
    branch = repo_data["default_branch"]
    branch_data = http_json(f"https://api.github.com/repos/{owner}/{repo}/branches/{urllib.parse.quote(branch)}")
    sha = branch_data["commit"]["sha"]
    return Candidate(value=sha, source=f"https://github.com/{owner}/{repo}/tree/{branch}", reason=f"default branch {branch} points at {sha[:12]}")


def github_container_candidate(entry: Entry, current: str) -> Candidate:
    owner_kind = entry.params["owner_kind"]
    owner = entry.params["owner"]
    package = urllib.parse.quote(entry.params["package"], safe="")
    strip_v = bool(entry.params.get("strip_v", True))
    url = f"https://api.github.com/{owner_kind}/{owner}/packages/container/{package}/versions?per_page=100"
    try:
        versions = http_json(url)
    except UpdateError as error:
        return Candidate(value=None, reason=f"GitHub package API unavailable for {owner}/{package}: {error}")
    tags = []
    for version in versions:
        tags.extend(version.get("metadata", {}).get("container", {}).get("tags", []))
    candidates = []
    for tag in tags:
        key = numeric_version_key(tag)
        if not key:
            continue
        value = strip_leading_v(tag) if strip_v else tag
        candidates.append((key, value, tag))
    if not candidates:
        return Candidate(value=None, reason=f"no numeric container tags found for {owner}/{package}")
    _key, value, tag = max(candidates, key=lambda item: item[0])
    reason = "current pin matches latest container tag" if value == current else f"latest container tag is {tag}"
    return Candidate(value=value, source=url, reason=reason)


def dockerhub_semver_candidate(entry: Entry, current: str) -> Candidate:
    namespace = entry.params["namespace"]
    repo = entry.params["repo"]
    strip_v = bool(entry.params.get("strip_v", False))
    full_patch = bool(entry.params.get("full_patch", False))
    same_major_minor = bool(entry.params.get("same_major_minor", False))
    ignore_arch = bool(entry.params.get("ignore_arch", False))
    tags = dockerhub_tags(namespace, repo)
    current_key = numeric_version_key(current)
    current_major_minor = current_key[:2] if same_major_minor and len(current_key) >= 2 else None
    candidates = []
    for tag in tags:
        name = str(tag.get("name", ""))
        if ignore_arch and re.search(r"-(amd64|arm64|armv7|armv6|386)$", name):
            continue
        value = strip_leading_v(name) if strip_v else name
        key = numeric_version_key(value)
        if not key:
            continue
        if full_patch and len(key) != 3:
            continue
        if current_major_minor and key[:2] != current_major_minor:
            continue
        candidates.append((key, value, name))
    if not candidates:
        return Candidate(value=None, reason=f"no acceptable Docker Hub tags found for {namespace}/{repo}")
    _key, value, tag = max(candidates, key=lambda item: item[0])
    reason = "current pin matches latest Docker Hub tag" if value == current else f"latest acceptable Docker Hub tag is {tag}"
    return Candidate(value=value, source=f"https://hub.docker.com/r/{namespace}/{repo}/tags", reason=reason)


def dockerhub_tags(namespace: str, repo: str, max_pages: int = 20) -> list[dict[str, Any]]:
    url = f"https://hub.docker.com/v2/repositories/{namespace}/{repo}/tags?page_size=100"
    tags = []
    try:
        for _page in range(max_pages):
            data = http_json(url)
            tags.extend(data.get("results", []))
            url = data.get("next")
            if not url:
                break
        return tags
    except UpdateError:
        return [{"name": name} for name in docker_registry_tags(namespace, repo)]


def docker_registry_tags(namespace: str, repo: str) -> list[str]:
    repository = f"{namespace}/{repo}"
    auth_url = "https://auth.docker.io/token?" + urllib.parse.urlencode(
        {
            "service": "registry.docker.io",
            "scope": f"repository:{repository}:pull",
        }
    )
    token = http_json(auth_url)["token"]
    tags_url = f"https://registry-1.docker.io/v2/{repository}/tags/list?n=10000"
    data = http_json(tags_url, headers={"Authorization": f"Bearer {token}"})
    return data.get("tags") or []


def citron_nightly_candidate() -> Candidate:
    release = http_json("https://api.github.com/repos/citron-neo/CI/releases/tags/nightly-linux")
    assets = release.get("assets", [])
    matches = []
    pattern = re.compile(r"^citron_(nightly-[^-]+)-linux-x86_64_v3\.AppImage$")
    for asset in assets:
        name = str(asset.get("name", ""))
        match = pattern.match(name)
        if not match:
            continue
        matches.append((asset.get("updated_at") or "", match.group(1), asset["browser_download_url"]))
    if not matches:
        return Candidate(value=None, reason="no citron nightly x86_64_v3 AppImage asset found")
    _updated_at, version, url = max(matches, key=lambda item: item[0])
    return Candidate(value=version, fields={"url": url}, source=release.get("html_url"), reason=f"latest nightly-linux x86_64_v3 asset is {version}")


def amo_addon_candidate(entry: Entry, current_pin: dict[str, Any]) -> Candidate:
    slug = entry.params["slug"]
    data = http_json(f"https://addons.mozilla.org/api/v5/addons/addon/{slug}/")
    current_version = data.get("current_version") or {}
    version = str(current_version.get("version") or "")
    if not version:
        return Candidate(value=None, reason=f"AMO did not report current_version.version for {slug}")
    files = current_version.get("files") or []
    file_url = None
    for addon_file in files:
        candidate_url = addon_file.get("url")
        if candidate_url and str(candidate_url).endswith(".xpi"):
            file_url = str(candidate_url)
            break
    if not file_url:
        file_url = str(current_pin.get("url", "")).replace(str(current_pin.get("version")), version)
    return Candidate(value=version, fields={"url": file_url}, source=data.get("url"), reason=f"AMO current version is {version}")


def refresh_hash_fields(entry: Entry, fields: dict[str, str]) -> dict[str, str]:
    fields = dict(fields)
    if entry.group in {"fetchurl", "firefox"} and "url" in fields:
        fields["sha256"] = prefetch_file_hash(fields["url"])
    if entry.group == "github" and entry.value_field in fields:
        owner = entry.params["owner"]
        repo = entry.params["repo"]
        fields["hash"] = prefetch_github_source_hash(owner, repo, fields[entry.value_field])
    return fields


def prefetch_file_hash(url: str) -> str:
    completed = run(["nix", "store", "prefetch-file", "--json", "--hash-type", "sha256", url], capture=True)
    data = json.loads(completed.stdout)
    try:
        return data["hash"]
    except KeyError as error:
        raise UpdateError(f"nix store prefetch-file did not return a hash for {url}") from error


def prefetch_github_source_hash(owner: str, repo: str, rev: str) -> str:
    archive_url = f"https://github.com/{owner}/{repo}/archive/{rev}.tar.gz"
    completed = run(["nix-prefetch-url", "--unpack", archive_url], capture=True)
    base32_hash = completed.stdout.strip().splitlines()[-1]
    converted = run(["nix", "hash", "convert", "--hash-algo", "sha256", "--to", "sri", base32_hash], capture=True)
    return converted.stdout.strip()


def replace_pin_fields(path: Path, pin_name: str, fields: dict[str, str]) -> None:
    lines = path.read_text().splitlines(keepends=True)
    start = None
    end = None
    block_pattern = re.compile(rf"^\s*{re.escape(pin_name)}\s*=\s*(?:rec\s*)?\{{\s*$")
    for index, line in enumerate(lines):
        if block_pattern.match(line):
            start = index
            break
    if start is None:
        raise UpdateError(f"could not find pin block {pin_name!r} in {path}")
    for index in range(start + 1, len(lines)):
        if re.match(r"^\s*};\s*$", lines[index]):
            end = index
            break
    if end is None:
        raise UpdateError(f"could not find end of pin block {pin_name!r} in {path}")

    remaining = set(fields)
    for index in range(start + 1, end):
        for field, value in list(fields.items()):
            field_pattern = re.compile(rf'^(\s*{re.escape(field)}\s*=\s*)"[^"]*"(\s*;.*)$')
            match = field_pattern.match(lines[index])
            if match:
                lines[index] = f'{match.group(1)}"{escape_nix_string(value)}"{match.group(2)}\n'
                remaining.discard(field)
    if remaining:
        missing = ", ".join(sorted(remaining))
        raise UpdateError(f"could not find fields in {path}:{pin_name}: {missing}")
    path.write_text("".join(lines))


def escape_nix_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"').replace("${", "\\${")


def validate_entries(entries: tuple[Entry, ...], *, flake_check: bool) -> None:
    run(["nix", "fmt"])
    run(["git", "diff", "--check"])
    commands = []
    for entry in entries:
        commands.extend(entry.validate)
    if flake_check:
        commands.append("nix flake check --no-build")
    for command in unique(commands):
        print(f"validating: {command}", file=sys.stderr)
        run_shell(command)


def changed_entries_from_git() -> tuple[Entry, ...]:
    completed = run(["git", "diff", "--name-only"], capture=True)
    changed = set(completed.stdout.splitlines())
    return tuple(entry for entry in ENTRIES if entry.file in changed)


def commit_changed_pin_files(*, push: bool, message: str = "chore: update manual dependency pins") -> None:
    completed = run(["git", "status", "--porcelain"], capture=True)
    status_lines = [line for line in completed.stdout.splitlines() if line]
    if not status_lines:
        print("no changes to commit")
        return

    allowed = set(PIN_FILES.values())
    changed_paths = {parse_status_path(line) for line in status_lines}
    disallowed = sorted(path for path in changed_paths if path not in allowed)
    if disallowed:
        raise UpdateError("refusing to commit non-pin changes: " + ", ".join(disallowed))

    run(["git", "add", *sorted(changed_paths)])
    staged = run(["git", "diff", "--cached", "--name-only"], capture=True).stdout.splitlines()
    if not staged:
        print("no staged changes to commit")
        return
    run(["git", "commit", "-m", message])
    if push:
        run(["git", "push"])


def parse_status_path(line: str) -> str:
    path = line[3:]
    if " -> " in path:
        path = path.split(" -> ", 1)[1]
    return path.strip()


def write_reports(results: list[Result], args: argparse.Namespace) -> None:
    if getattr(args, "write_json", None):
        Path(args.write_json).write_text(json_report(results) + "\n")
    if getattr(args, "write_markdown", None):
        Path(args.write_markdown).write_text(markdown_report(results) + "\n")
    if args.format == "json":
        print(json_report(results))
    elif args.format == "markdown":
        print(markdown_report(results))
    else:
        print(human_report(results))


def json_report(results: list[Result]) -> str:
    payload = {
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "entries": [dataclasses.asdict(result) for result in results],
    }
    return json.dumps(payload, indent=2, sort_keys=True)


def markdown_report(results: list[Result]) -> str:
    lines = [
        "# suderpkgs update report",
        "",
        f"Generated: {datetime.now(timezone.utc).isoformat()}",
        "",
        "| Entry | Policy | Current | Candidate | Action | Reason |",
        "| --- | --- | --- | --- | --- | --- |",
    ]
    for result in results:
        lines.append(
            "| "
            + " | ".join(
                markdown_cell(value)
                for value in (
                    result.name,
                    result.policy,
                    result.current or "",
                    result.candidate or "",
                    result.action,
                    display_reason(result, limit=220),
                )
            )
            + " |"
        )
    return "\n".join(lines)


def markdown_cell(value: str) -> str:
    return compact_text(str(value)).replace("|", "\\|")


def human_report(results: list[Result]) -> str:
    sections = [
        ("Updated", [result for result in results if result.action == "updated"]),
        (
            "Safe updates available",
            [result for result in results if result.action == "update-available" and result.policy == "auto"],
        ),
        ("Needs review", [result for result in results if result.action == "skipped-review-required"]),
        ("Report-only", [result for result in results if result.action == "skipped-report-only"]),
        ("Current newer than upstream", [result for result in results if result.action == "current-newer"]),
        ("Failed", [result for result in results if result.action == "failed"]),
        ("Unsupported", [result for result in results if result.action == "unsupported"]),
    ]
    up_to_date = [result.name for result in results if result.action == "up-to-date"]

    lines = ["suderpkgs update check"]
    wrote_section = False
    for title, section_results in sections:
        if not section_results:
            continue
        wrote_section = True
        lines.extend(["", f"{title}:"])
        lines.extend(f"  {human_result_line(result)}" for result in section_results)

    if up_to_date:
        lines.extend(["", "Up to date:", f"  {', '.join(up_to_date)}"])

    if not wrote_section and not up_to_date:
        lines.append("  No entries checked.")

    return "\n".join(lines)


def human_result_line(result: Result) -> str:
    reason = display_reason(result, limit=120)
    if result.action == "current-newer":
        return f"{result.name}: current {result.current}, upstream {result.candidate} ({reason})"
    if result.current and result.candidate and result.current != result.candidate:
        return f"{result.name}: {result.current} -> {result.candidate} ({reason})"
    if result.current:
        return f"{result.name}: {result.current} ({reason})"
    return f"{result.name}: {reason}"


def display_reason(result: Result, *, limit: int) -> str:
    reason = compact_text(result.reason)
    if "packages/container" in reason and ("read:packages" in reason or "HTTP 401" in reason or "HTTP 403" in reason):
        reason = "GitHub Packages API requires read:packages access"
    reason = re.sub(r" failed with HTTP (\d+): \{.*$", r" failed with HTTP \1", reason)
    if len(reason) <= limit:
        return reason
    return reason[: limit - 1].rstrip() + "…"


def compact_text(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def numeric_version_key(value: str) -> tuple[int, ...]:
    normalized = strip_leading_v(value)
    if not re.fullmatch(r"\d+(?:\.\d+)*", normalized):
        return ()
    return tuple(int(part) for part in normalized.split("."))


def candidate_is_downgrade(current: str, candidate: str) -> bool:
    current_key = numeric_version_key(current)
    candidate_key = numeric_version_key(candidate)
    return bool(current_key and candidate_key and candidate_key < current_key)


def strip_leading_v(value: str) -> str:
    return value[1:] if value.startswith("v") and len(value) > 1 and value[1].isdigit() else value


def http_json(url: str, headers: dict[str, str] | None = None) -> Any:
    request = urllib.request.Request(url, headers=http_headers(url) | (headers or {}))
    try:
        with urllib.request.urlopen(request, timeout=60) as response:  # noqa: S310 - fixed upstream APIs.
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")[:500]
        raise UpdateError(f"GET {url} failed with HTTP {error.code}: {detail}") from error
    except urllib.error.URLError as error:
        raise UpdateError(f"GET {url} failed: {error}") from error


def http_headers(url: str) -> dict[str, str]:
    headers = {"User-Agent": USER_AGENT, "Accept": "application/json"}
    token = os.environ.get("GITHUB_TOKEN")
    if token and urllib.parse.urlparse(url).netloc == "api.github.com":
        headers["Authorization"] = f"Bearer {token}"
    return headers


def run(command: list[str], *, capture: bool = False) -> subprocess.CompletedProcess[str]:
    try:
        return subprocess.run(
            command,
            cwd=ROOT,
            check=True,
            text=True,
            stdout=subprocess.PIPE if capture else None,
            stderr=subprocess.PIPE if capture else None,
        )
    except FileNotFoundError as error:
        raise UpdateError(f"required command not found: {command[0]}") from error
    except subprocess.CalledProcessError as error:
        stderr = error.stderr.strip() if error.stderr else ""
        stdout = error.stdout.strip() if error.stdout else ""
        detail = stderr or stdout or f"exit status {error.returncode}"
        raise UpdateError(f"command failed: {' '.join(command)}\n{detail}") from error


def run_shell(command: str) -> None:
    try:
        subprocess.run(command, cwd=ROOT, check=True, shell=True)
    except subprocess.CalledProcessError as error:
        raise UpdateError(f"validation failed: {command}") from error


def unique(values: list[str]) -> list[str]:
    seen = set()
    result = []
    for value in values:
        if value in seen:
            continue
        seen.add(value)
        result.append(value)
    return result


if __name__ == "__main__":
    raise SystemExit(main())

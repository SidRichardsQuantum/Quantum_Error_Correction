#!/usr/bin/env python3
"""Check generated GitHub Pages HTML for broken internal links and assets."""

from __future__ import annotations

from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlparse


ROOT = Path(__file__).resolve().parents[1]
SITE = (ROOT / "_site").resolve()


class LinkParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.links: list[tuple[str, str]] = []
        self.ids: set[str] = set()

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = {key: value for key, value in attrs if value is not None}
        if "id" in values:
            self.ids.add(values["id"])
        for key in ("href", "src"):
            if key in values:
                self.links.append((key, values[key]))


def parse_html(path: Path) -> LinkParser:
    parser = LinkParser()
    parser.feed(path.read_text(encoding="utf-8", errors="ignore"))
    return parser


def main() -> int:
    if not SITE.exists():
        raise SystemExit("Missing _site; run python3 tools/build_pages_site.py first.")

    ids_cache: dict[Path, set[str]] = {}
    broken: list[tuple[Path, str, str]] = []

    for html_file in SITE.rglob("*.html"):
        parser = parse_html(html_file)
        ids_cache[html_file.resolve()] = parser.ids

        for _, url in parser.links:
            parsed = urlparse(url)
            if parsed.scheme in ("http", "https", "mailto") or url.startswith("data:"):
                continue

            if not parsed.path:
                target = html_file.resolve()
            else:
                target = (html_file.parent / unquote(parsed.path)).resolve()

            try:
                target.relative_to(SITE)
            except ValueError:
                broken.append((html_file.relative_to(SITE), url, "escapes _site"))
                continue

            if not target.exists():
                broken.append((html_file.relative_to(SITE), url, "missing target"))
                continue

            if parsed.fragment and target.suffix == ".html":
                ids = ids_cache.get(target)
                if ids is None:
                    ids = parse_html(target).ids
                    ids_cache[target] = ids
                if parsed.fragment not in ids:
                    broken.append((html_file.relative_to(SITE), url, "missing anchor"))

    if broken:
        for source, url, reason in broken:
            print(f"{source} -> {url}: {reason}")
        return 1

    print("All generated internal links and assets resolved.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

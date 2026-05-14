#!/usr/bin/env python3
"""Build a lightweight GitHub Pages site from repository markdown assets."""

from __future__ import annotations

import html
import json
import os
import re
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "_site"
REPO_URL = "https://github.com/SidRichardsQuantum/Quantum_Error_Correction"
PAGES_URL = "https://sidrichardsquantum.github.io/Quantum_Error_Correction/"
PORTFOLIO_URL = "https://sidrichardsquantum.github.io/"


DOC_PAGES = [
    ("README.md", "Overview"),
    ("docs/ALGORITHMS.md", "Algorithms"),
    ("docs/USAGE.md", "Usage"),
    ("docs/THEORY.md", "Theory"),
    ("docs/RESULTS.md", "Results"),
    ("docs/SURFACE3.md", "Surface-3"),
    ("docs/SIMULATION_REPORT.md", "Simulation Report"),
    ("docs/setup.md", "Setup"),
    ("docs/REPOSITORY_LAYOUT.md", "Repository Layout"),
    ("docs/ROADMAP.md", "Roadmap"),
    ("CONTRIBUTING.md", "Contributing"),
    ("docs/algorithms/BITFLIP.md", "Bit-Flip"),
    ("docs/algorithms/PHASEFLIP.md", "Phase-Flip"),
    ("docs/algorithms/FIVE_QUBIT.md", "5-Qubit"),
    ("docs/algorithms/STEANE.md", "Steane"),
    ("docs/algorithms/SHOR.md", "Shor"),
    ("docs/algorithms/COLOR7.md", "Color-7"),
    ("docs/algorithms/BACON_SHOR.md", "Bacon-Shor"),
    ("docs/algorithms/REPETITION_DECODER.md", "Repetition Decoder"),
    ("docs/algorithms/SURFACE_DISTANCE.md", "Surface Distance"),
]


FIGURES = [
    ("images/bitflip_logical_error_vs_physical_error.png", "Bit-flip logical error vs physical error"),
    ("images/bitflip_syndrome_distribution.png", "Bit-flip syndrome distribution"),
    ("images/bitflip_decoder_confusion_matrix.png", "Bit-flip decoder confusion matrix"),
    ("images/bitflip_error_weight_distribution.png", "Bit-flip error weight distribution"),
    ("images/bitflip_monte_carlo_demo.png", "Bit-flip Monte Carlo demo"),
    ("images/qec_recovery_failure_by_error_weight.png", "Recovery failure by error weight"),
    ("images/qec_depolarizing_logical_error_comparison.png", "Depolarizing logical error comparison"),
    ("images/bitflip_noisy_syndrome_rounds.png", "Bit-flip noisy syndrome rounds"),
    ("images/surface3_logical_error_vs_x_error.png", "Surface-3 logical error vs X error"),
    ("images/surface3_channel_logical_error_comparison.png", "Surface-3 channel comparison"),
    ("images/surface3_noisy_syndrome_rounds.png", "Surface-3 noisy syndrome rounds"),
    ("images/surface_distance_logical_error_scaling.png", "Surface distance logical error scaling"),
]


CODE_DOCS = [
    {
        "title": "3-Qubit Bit-Flip",
        "summary": "Encode, syndrome extraction, correction, Monte Carlo logical-error sweeps, and noisy syndrome rounds.",
        "tags": ["3 qubits", "X errors", "Monte Carlo"],
        "href": "docs/algorithms/BITFLIP.html",
    },
    {
        "title": "3-Qubit Phase-Flip",
        "summary": "X-basis repetition code with X-parity syndrome checks and single Z-error recovery.",
        "tags": ["3 qubits", "Z errors", "X checks"],
        "href": "docs/algorithms/PHASEFLIP.html",
    },
    {
        "title": "5-Qubit Perfect Code",
        "summary": "Distance-3 stabilizer code with syndrome-table recovery for arbitrary single-qubit Pauli errors.",
        "tags": ["5 qubits", "stabilizer", "Pauli recovery"],
        "href": "docs/algorithms/FIVE_QUBIT.html",
    },
    {
        "title": "7-Qubit Steane",
        "summary": "CSS code using Hamming parity checks with separate X/Z syndrome decoding.",
        "tags": ["7 qubits", "CSS", "Hamming"],
        "href": "docs/algorithms/STEANE.html",
    },
    {
        "title": "9-Qubit Shor",
        "summary": "Concatenated-style repetition structure with bit and phase syndromes for single-Pauli recovery.",
        "tags": ["9 qubits", "Shor", "single Pauli"],
        "href": "docs/algorithms/SHOR.html",
    },
    {
        "title": "3x3 Bacon-Shor",
        "summary": "Subsystem-code Pauli-frame model with row/column syndromes, representative corrections, and logical residual checks.",
        "tags": ["9 qubits", "subsystem", "Pauli frame"],
        "href": "docs/algorithms/BACON_SHOR.html",
    },
    {
        "title": "Surface-3 Prototype",
        "summary": "Compact 9-data-qubit surface-code model with X/Z/Pauli channels, noisy syndrome rounds, and a circuit-level schedule prototype.",
        "tags": ["surface code", "matching lookup", "schedule"],
        "href": "docs/SURFACE3.html",
    },
]


def clean_site() -> None:
    if SITE.exists():
        shutil.rmtree(SITE)
    SITE.mkdir(parents=True)
    (SITE / ".nojekyll").write_text("", encoding="utf-8")


def copy_tree(src: str) -> None:
    source = ROOT / src
    if source.exists():
        shutil.copytree(source, SITE / src, dirs_exist_ok=True)


def copy_static_assets() -> None:
    for name in ["images", "src", "examples", "tests", "cache", "docs"]:
        copy_tree(name)
    for name in ["README.md", "LICENSE", "CITATION.cff", "CONTRIBUTING.md", "DESCRIPTION", "INDEX"]:
        source = ROOT / name
        if source.exists():
            shutil.copy2(source, SITE / name)


def slugify(text: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return slug or "section"


def page_href(markdown_path: str) -> str:
    path = Path(markdown_path)
    if markdown_path == "README.md":
        return "README.html"
    return str(path.with_suffix(".html"))


def rewrite_href(href: str, source_path: str = "README.md", output_href: str = "index.html") -> str:
    if href.startswith(("http://", "https://", "mailto:", "#")):
        return href
    base, sep, anchor = href.partition("#")
    if not base:
        return href

    source_dir = Path(source_path).parent
    candidate = (source_dir / base).resolve().relative_to(ROOT)
    if not (ROOT / candidate).exists() and (ROOT / base).exists():
        candidate = Path(base)

    target = candidate.with_suffix(".html") if candidate.suffix == ".md" else candidate
    output_dir = Path(output_href).parent
    rel = os.path.relpath(target, output_dir).replace(os.sep, "/")
    return rel + (sep + anchor if sep else "")


def inline_markdown(text: str, source_path: str = "README.md", output_href: str = "index.html") -> str:
    placeholders: list[str] = []

    def stash(value: str) -> str:
        placeholders.append(value)
        return f"\u0000{len(placeholders) - 1}\u0000"

    text = html.escape(text, quote=False)

    text = re.sub(
        r"!\[([^\]]*)\]\(([^)]+)\)",
        lambda m: stash(f'<img src="{html.escape(m.group(2), quote=True)}" alt="{html.escape(m.group(1), quote=True)}">'),
        text,
    )
    text = re.sub(
        r"\[([^\]]+)\]\(([^)]+)\)",
        lambda m: stash(f'<a href="{html.escape(rewrite_href(m.group(2), source_path, output_href), quote=True)}">{m.group(1)}</a>'),
        text,
    )
    text = re.sub(r"`([^`]+)`", lambda m: stash(f"<code>{m.group(1)}</code>"), text)
    text = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", text)
    text = re.sub(r"\*([^*]+)\*", r"<em>\1</em>", text)

    for idx, value in enumerate(placeholders):
        text = text.replace(f"\u0000{idx}\u0000", value)
    return text


def render_table(lines: list[str], source_path: str = "README.md", output_href: str = "index.html") -> str:
    rows = []
    for line in lines:
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        rows.append(cells)
    if len(rows) > 1 and all(re.fullmatch(r":?-{3,}:?", cell) for cell in rows[1]):
        header = rows[0]
        body = rows[2:]
    else:
        header = []
        body = rows

    out = ['<div class="table-wrap"><table>']
    if header:
        out.append("<thead><tr>")
        out.extend(f"<th>{inline_markdown(cell, source_path, output_href)}</th>" for cell in header)
        out.append("</tr></thead>")
    out.append("<tbody>")
    for row in body:
        out.append("<tr>")
        out.extend(f"<td>{inline_markdown(cell, source_path, output_href)}</td>" for cell in row)
        out.append("</tr>")
    out.append("</tbody></table></div>")
    return "\n".join(out)


def markdown_to_html(markdown: str, source_path: str = "README.md", output_href: str = "index.html") -> str:
    lines = markdown.splitlines()
    out: list[str] = []
    paragraph: list[str] = []
    list_items: list[str] = []
    code: list[str] = []
    in_code = False
    code_lang = ""

    def flush_paragraph() -> None:
        nonlocal paragraph
        if paragraph:
            out.append(f"<p>{inline_markdown(' '.join(paragraph), source_path, output_href)}</p>")
            paragraph = []

    def flush_list() -> None:
        nonlocal list_items
        if list_items:
            out.append("<ul>")
            out.extend(f"<li>{item}</li>" for item in list_items)
            out.append("</ul>")
            list_items = []

    idx = 0
    while idx < len(lines):
        line = lines[idx]

        if in_code:
            if line.startswith("```"):
                lang = f" language-{html.escape(code_lang)}" if code_lang else ""
                out.append(f'<pre><code class="{lang.strip()}">{html.escape(chr(10).join(code))}</code></pre>')
                code = []
                in_code = False
                code_lang = ""
            else:
                code.append(line)
            idx += 1
            continue

        if line.startswith("```"):
            flush_paragraph()
            flush_list()
            in_code = True
            code_lang = line[3:].strip()
            idx += 1
            continue

        if not line.strip():
            flush_paragraph()
            flush_list()
            idx += 1
            continue

        if line.lstrip().startswith("<"):
            flush_paragraph()
            flush_list()
            out.append(line)
            idx += 1
            continue

        if line.startswith("|") and "|" in line[1:]:
            flush_paragraph()
            flush_list()
            table_lines = []
            while idx < len(lines) and lines[idx].startswith("|") and "|" in lines[idx][1:]:
                table_lines.append(lines[idx])
                idx += 1
            out.append(render_table(table_lines, source_path, output_href))
            continue

        heading = re.match(r"^(#{1,6})\s+(.+)$", line)
        if heading:
            flush_paragraph()
            flush_list()
            level = len(heading.group(1))
            title = heading.group(2).strip()
            out.append(f'<h{level} id="{slugify(title)}">{inline_markdown(title, source_path, output_href)}</h{level}>')
            idx += 1
            continue

        item = re.match(r"^\s*[-*]\s+(.+)$", line)
        if item:
            flush_paragraph()
            list_items.append(inline_markdown(item.group(1).strip(), source_path, output_href))
            idx += 1
            continue

        paragraph.append(line.strip())
        idx += 1

    flush_paragraph()
    flush_list()
    return "\n".join(out)


def extract_title(markdown: str, fallback: str) -> str:
    for line in markdown.splitlines():
        if line.startswith("# "):
            return line[2:].strip()
    return fallback


def plain_text(markdown: str) -> str:
    text = re.sub(r"```.*?```", " ", markdown, flags=re.S)
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"!\[[^\]]*\]\([^)]+\)", " ", text)
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"[#*_`|>-]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def root_prefix_for(output_href: str) -> str:
    depth = len(Path(output_href).parent.parts)
    return "../" * depth


def render_shell(title: str, body: str, active: str = "docs", root_prefix: str = "") -> str:
    nav = [
        (f"{root_prefix}index.html#codes", "Codes", "codes"),
        (f"{root_prefix}index.html#figures", "Figures", "figures"),
        (f"{root_prefix}index.html#docs", "Docs", "docs"),
        (f"{root_prefix}index.html#source", "Source", "source"),
        (f"{root_prefix}index.html#search", "Search", "search"),
    ]
    nav_links = "\n".join(
        f'<a href="{href}"{" aria-current=\"page\"" if key == active else ""}>{label}</a>'
        for href, label, key in nav
    )
    return f"""<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Quantum Error Correction MATLAB/Octave implementations, documentation, figures, and simulations.">
    <meta property="og:type" content="website">
    <meta property="og:title" content="{html.escape(title)}">
    <meta property="og:description" content="Small MATLAB/Octave quantum error-correction codes, decoders, simulations, and generated figures.">
    <meta property="og:url" content="{PAGES_URL}">
    <meta name="theme-color" content="#0f5364">
    <title>{html.escape(title)} | Quantum Error Correction</title>
    <link rel="stylesheet" href="{root_prefix}assets/styles.css">
    <script>
      window.MathJax = {{
        tex: {{
          inlineMath: [['$', '$'], ['\\\\(', '\\\\)']],
          displayMath: [['$$', '$$'], ['\\\\[', '\\\\]']]
        }},
        svg: {{ fontCache: 'global' }}
      }};
    </script>
    <script defer src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js"></script>
  </head>
  <body>
    <a class="skip-link" href="#top">Skip to main content</a>
    <header class="site-header">
      <a class="brand" href="{root_prefix}index.html#top" aria-label="Quantum Error Correction home">
        <span class="brand-mark">QEC</span>
        <span>Quantum Error Correction</span>
      </a>
      <nav class="nav-links" aria-label="Primary navigation">
        {nav_links}
      </nav>
    </header>
    <main id="top" tabindex="-1">
      {body}
    </main>
    <footer class="site-footer">
      <span>Quantum_Error_Correction by Sid Richards</span>
      <span><a href="{PORTFOLIO_URL}">Main portfolio</a> · <a href="{REPO_URL}">GitHub repository</a></span>
    </footer>
    <script>window.SITE_ROOT = "{root_prefix}";</script>
    <script src="{root_prefix}assets/search.js"></script>
  </body>
</html>
"""


def tags_html(tags: list[str]) -> str:
    return '<div class="tags">' + "".join(f"<span>{html.escape(tag)}</span>" for tag in tags) + "</div>"


def build_index() -> None:
    code_cards = []
    for item in CODE_DOCS:
        code_cards.append(
            f"""<article class="project-card">
  <div>
    <h3>{html.escape(item["title"])}</h3>
    <p>{html.escape(item["summary"])}</p>
  </div>
  {tags_html(item["tags"])}
  <div class="card-links"><a href="{item["href"]}">Implementation notes</a></div>
</article>"""
        )

    docs_rows = []
    for path, label in DOC_PAGES:
        docs_rows.append(
            f"""<article class="package-row">
  <div><h3>{html.escape(label)}</h3><p>{html.escape(path)}</p></div>
  <div class="badges"><span>Markdown</span><span>HTML</span></div>
  <a href="{page_href(path)}">Open</a>
</article>"""
        )
    docs_rows.append(
        """<article class="package-row">
  <div><h3>API and Source Reference</h3><p>Generated from src/, examples/, and tests/ first-line comments</p></div>
  <div class="badges"><span>Generated</span><span>HTML</span></div>
  <a href="api.html">Open</a>
</article>"""
    )

    figure_cards = []
    for path, caption in FIGURES:
        if (ROOT / path).exists():
            figure_cards.append(
                f"""<figure class="figure-card">
  <a href="{path}"><img src="{path}" alt="{html.escape(caption)}"></a>
  <figcaption>{html.escape(caption)}</figcaption>
</figure>"""
            )

    body = f"""<section class="hero section">
  <div class="hero-copy">
    <p class="eyebrow">MATLAB/Octave QEC simulations</p>
    <h1>Quantum Error Correction</h1>
    <p class="hero-text">
      Educational implementations of small quantum error-correction codes,
      syndrome decoders, Monte Carlo sweeps, generated reports, and reusable
      figures for studying logical recovery under simple Pauli noise models.
    </p>
    <div class="hero-actions" aria-label="Project links">
      <a class="button primary" href="{REPO_URL}">GitHub</a>
      <a class="button" href="README.html">README</a>
      <a class="button" href="docs/ALGORITHMS.html">Algorithms</a>
      <a class="button" href="docs/USAGE.html">User Guide</a>
      <a class="button" href="api.html">API Reference</a>
    </div>
  </div>
  <div class="hero-side">
    <div class="hero-visual" aria-hidden="true">
      <svg viewBox="0 0 520 360" role="presentation" focusable="false">
        <defs><pattern id="qec-grid" width="40" height="40" patternUnits="userSpaceOnUse"><path d="M40 0H0V40" /></pattern></defs>
        <rect class="visual-bg" width="520" height="360" rx="8" />
        <rect class="visual-grid" width="520" height="360" rx="8" fill="url(#qec-grid)" />
        <g class="visual-circuit">
          <path d="M92 76h352M92 126h352M92 176h352M92 246h352M92 296h352" />
          <path d="M188 76v170M258 126v120M316 126v170M374 176v120" />
          <circle cx="188" cy="76" r="11" /><circle cx="258" cy="126" r="11" />
          <circle cx="316" cy="126" r="11" /><circle cx="374" cy="176" r="11" />
          <circle cx="188" cy="246" r="15" /><path d="M188 231v30M173 246h30" />
          <circle cx="258" cy="246" r="15" /><path d="M258 231v30M243 246h30" />
          <circle cx="316" cy="296" r="15" /><path d="M316 281v30M301 296h30" />
          <circle cx="374" cy="296" r="15" /><path d="M374 281v30M359 296h30" />
          <rect x="424" y="226" width="42" height="40" rx="8" />
          <rect x="424" y="276" width="42" height="40" rx="8" />
          <path d="M434 255q11 -20 22 0M434 305q11 -20 22 0" />
        </g>
        <g class="visual-labels">
          <text x="48" y="82">q1</text><text x="48" y="132">q2</text><text x="48" y="182">q3</text>
          <text x="36" y="252">a12</text><text x="36" y="302">a23</text>
          <text x="118" y="332">3-qubit bit-flip syndrome: measure Z1Z2 and Z2Z3</text>
        </g>
      </svg>
    </div>
    <aside class="focus-panel" aria-label="Repository focus">
      <h2>Repository Focus</h2>
      <ul>
        <li>Bit-flip, phase-flip, Shor, Steane, Bacon-Shor, and 5-qubit codes</li>
        <li>Surface-3 prototype with cached minimum-weight lookups</li>
        <li>Depolarizing, code-capacity, and noisy-syndrome simulations</li>
        <li>Generated figures, reports, examples, and Octave tests</li>
      </ul>
    </aside>
  </div>
</section>

<section id="codes" class="section">
  <div class="section-heading">
    <p class="eyebrow">Implemented schemes</p>
    <h2>Algorithms and Codes</h2>
    <p>Focused implementation pages preserve the scientific details while giving each code its own entry point.</p>
  </div>
  <div class="project-grid">{''.join(code_cards)}</div>
</section>

<section id="figures" class="section">
  <div class="section-heading">
    <p class="eyebrow">Generated artefacts</p>
    <h2>Figure Dashboard</h2>
    <p>Committed PNG outputs remain available as direct image assets and as part of the results documentation.</p>
  </div>
  <div class="figure-grid">{''.join(figure_cards)}</div>
</section>

<section id="docs" class="section">
  <div class="section-heading">
    <p class="eyebrow">Documentation</p>
    <h2>Docs, Guides, and Reports</h2>
    <p>All markdown documentation is published as styled HTML and copied as raw markdown for reproducibility.</p>
  </div>
  <div class="package-list">{''.join(docs_rows)}</div>
</section>

<section id="source" class="section split-section">
  <div class="section-heading">
    <p class="eyebrow">Source reference</p>
    <h2>Code, Examples, Tests</h2>
    <p>Project-specific implementation files are copied into the site artifact so source links and examples remain accessible.</p>
  </div>
  <div class="focus-panel link-panel">
    <a href="api.html">API and source reference</a>
    <a href="src/">Source functions</a>
    <a href="examples/">Examples and plot scripts</a>
    <a href="tests/">Octave test suite</a>
    <a href="cache/">Cached simulation artefacts</a>
    <a href="LICENSE">License</a>
  </div>
</section>

<section id="search" class="section">
  <div class="section-heading">
    <p class="eyebrow">Search</p>
    <h2>Search Documentation</h2>
    <p>Client-side search covers the README, guides, algorithm notes, results, and generated simulation report.</p>
  </div>
  <div class="search-panel">
    <label for="site-search">Search docs</label>
    <input id="site-search" type="search" placeholder="Try Steane, noisy syndrome, surface-3, depolarizing..." autocomplete="off">
    <div id="search-results" class="search-results" aria-live="polite"></div>
  </div>
</section>"""
    (SITE / "index.html").write_text(render_shell("Quantum Error Correction", body, "codes"), encoding="utf-8")


def build_doc_pages() -> list[dict[str, str]]:
    search_docs = []
    for path, label in DOC_PAGES:
        source = ROOT / path
        if not source.exists():
            continue
        markdown = source.read_text(encoding="utf-8")
        title = extract_title(markdown, label)
        href = page_href(path)
        output = SITE / href
        output.parent.mkdir(parents=True, exist_ok=True)
        root_prefix = root_prefix_for(href)
        body = f"""<section class="section doc-layout">
  <div class="doc-header">
    <p class="eyebrow">Documentation</p>
    <h1>{html.escape(title)}</h1>
    <div class="hero-actions">
      <a class="button" href="{root_prefix}index.html#docs">All docs</a>
      <a class="button" href="{root_prefix}{path}">Raw markdown</a>
      <a class="button" href="{REPO_URL}/blob/main/{path}">View on GitHub</a>
    </div>
  </div>
  <article class="markdown-body">{markdown_to_html(markdown, path, href)}</article>
</section>"""
        output.write_text(render_shell(title, body, "docs", root_prefix), encoding="utf-8")
        search_docs.append({"title": title, "href": href, "text": plain_text(markdown)})
    return search_docs


def first_comment_summary(path: Path) -> str:
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith("%"):
            return stripped.lstrip("%").strip()
        return "Source file"
    return "Source file"


def api_section(title: str, pattern: str) -> str:
    rows = []
    for path in sorted(ROOT.glob(pattern)):
        if path.is_file():
            rel = path.relative_to(ROOT).as_posix()
            rows.append(
                f"""<article class="package-row">
  <div><h3>{html.escape(path.name)}</h3><p>{html.escape(first_comment_summary(path))}</p></div>
  <div class="badges"><span>{html.escape(path.suffix.lstrip('.'))}</span></div>
  <a href="{rel}">Open source</a>
</article>"""
            )
    return f"""<section class="api-block">
  <h2>{html.escape(title)}</h2>
  <div class="package-list">{''.join(rows)}</div>
</section>"""


def build_api_page() -> dict[str, str]:
    body = f"""<section class="section doc-layout">
  <div class="doc-header">
    <p class="eyebrow">Source reference</p>
    <h1>API and Source Reference</h1>
    <p class="hero-text">Generated from repository source files and first-line comments during the Pages build.</p>
    <div class="hero-actions">
      <a class="button" href="index.html#source">Source section</a>
      <a class="button" href="{REPO_URL}/tree/main/src">View src on GitHub</a>
      <a class="button" href="{REPO_URL}/tree/main/examples">View examples on GitHub</a>
    </div>
  </div>
  {api_section("Core MATLAB/Octave Functions", "src/*.m")}
  {api_section("Examples and Plot Scripts", "examples/*.m")}
  {api_section("Tests", "tests/*.m")}
</section>"""
    (SITE / "api.html").write_text(render_shell("API and Source Reference", body, "source"), encoding="utf-8")

    summaries = []
    for pattern in ["src/*.m", "examples/*.m", "tests/*.m"]:
        summaries.extend(first_comment_summary(path) for path in sorted(ROOT.glob(pattern)))
    text = "Generated API and source reference for src, examples, and tests. " + " ".join(summaries)
    return {"title": "API and Source Reference", "href": "api.html", "text": text}


def write_assets(search_docs: list[dict[str, str]]) -> None:
    assets = SITE / "assets"
    assets.mkdir(parents=True, exist_ok=True)
    (assets / "search-index.json").write_text(json.dumps(search_docs, indent=2), encoding="utf-8")
    (assets / "search.js").write_text(SEARCH_JS, encoding="utf-8")
    (assets / "styles.css").write_text(STYLES_CSS, encoding="utf-8")


SEARCH_JS = """
async function initSearch() {
  const input = document.getElementById("site-search");
  const results = document.getElementById("search-results");
  if (!input || !results) return;
  const root = window.SITE_ROOT || "";
  const response = await fetch(root + "assets/search-index.json");
  const docs = await response.json();
  function render() {
    const query = input.value.trim().toLowerCase();
    if (!query) {
      results.innerHTML = "<p>Enter a term to search the documentation.</p>";
      return;
    }
    const terms = query.split(/\\s+/).filter(Boolean);
    const matches = docs
      .map((doc) => {
        const haystack = (doc.title + " " + doc.text).toLowerCase();
        const score = terms.reduce((acc, term) => acc + (haystack.includes(term) ? 1 : 0), 0);
        return { ...doc, score };
      })
      .filter((doc) => doc.score > 0)
      .sort((a, b) => b.score - a.score || a.title.localeCompare(b.title))
      .slice(0, 8);
    if (!matches.length) {
      results.innerHTML = "<p>No documentation matches found.</p>";
      return;
    }
    results.innerHTML = matches
      .map((doc) => `<a class="search-result" href="${root}${doc.href}"><strong>${doc.title}</strong><span>${doc.text.slice(0, 180)}...</span></a>`)
      .join("");
  }
  input.addEventListener("input", render);
  render();
}
initSearch();
""".strip()


STYLES_CSS = """
:root {
  color-scheme: light dark;
  --bg: #f7f7f4;
  --surface: #ffffff;
  --surface-muted: #ededeb;
  --text: #1d2328;
  --muted: #5b6670;
  --line: #d7d9d6;
  --accent: #126c83;
  --accent-strong: #0f5364;
  --accent-soft: #dceff3;
  --code-bg: #eef2f1;
  --shadow: 0 18px 45px rgba(34, 41, 47, 0.08);
  --shadow-soft: 0 10px 30px rgba(34, 41, 47, 0.06);
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #101416;
    --surface: #171d20;
    --surface-muted: #20282b;
    --text: #edf1f2;
    --muted: #a9b4b8;
    --line: #2e393d;
    --accent: #66c5d7;
    --accent-strong: #9eddea;
    --accent-soft: #17333a;
    --code-bg: #11191c;
    --shadow: 0 18px 45px rgba(0, 0, 0, 0.25);
    --shadow-soft: 0 10px 30px rgba(0, 0, 0, 0.18);
  }
}

* { box-sizing: border-box; }
html { scroll-behavior: smooth; }
body {
  margin: 0;
  background: var(--bg);
  color: var(--text);
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  line-height: 1.6;
  text-rendering: optimizeLegibility;
}
a {
  color: inherit;
  text-decoration-color: color-mix(in srgb, var(--accent) 65%, transparent);
  text-underline-offset: 0.2em;
}
a:hover { color: var(--accent-strong); }
a:focus-visible, main:focus-visible, input:focus-visible {
  outline: 3px solid var(--accent);
  outline-offset: 4px;
}
.skip-link {
  position: fixed;
  top: 0.75rem;
  left: 0.75rem;
  z-index: 20;
  transform: translateY(-150%);
  border: 1px solid var(--accent-strong);
  border-radius: 8px;
  padding: 0.65rem 0.9rem;
  background: var(--surface);
  color: var(--accent-strong);
  font-weight: 800;
  text-decoration: none;
  box-shadow: var(--shadow);
  transition: transform 160ms ease;
}
.skip-link:focus-visible { transform: translateY(0); }
.site-header {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1.5rem;
  padding: 1rem clamp(1rem, 4vw, 3rem);
  border-bottom: 1px solid var(--line);
  background: color-mix(in srgb, var(--bg) 88%, transparent);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
}
.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.7rem;
  font-weight: 700;
  text-decoration: none;
}
.brand-mark {
  display: inline-grid;
  width: 2.2rem;
  height: 2.2rem;
  place-items: center;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--surface);
  color: var(--accent-strong);
  font-size: 0.82rem;
  letter-spacing: 0;
}
.nav-links {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 0.35rem 1rem;
  color: var(--muted);
  font-size: 0.95rem;
}
.nav-links a {
  border-radius: 6px;
  padding: 0.15rem 0;
  text-decoration: none;
}
.nav-links a[aria-current="page"] { color: var(--accent-strong); font-weight: 800; }
.section {
  width: min(1120px, calc(100% - 2rem));
  margin: 0 auto;
  padding: clamp(3rem, 8vw, 6rem) 0;
  scroll-margin-top: 6rem;
}
.hero {
  display: grid;
  grid-template-columns: minmax(0, 1.15fr) minmax(320px, 0.85fr);
  align-items: center;
  gap: clamp(2rem, 5vw, 4rem);
  min-height: calc(100vh - 5rem);
}
.hero-copy h1 {
  max-width: 10ch;
  margin: 0;
  font-size: clamp(3.7rem, 12vw, 8rem);
  line-height: 0.9;
  letter-spacing: 0;
}
.eyebrow {
  margin: 0 0 0.75rem;
  color: var(--accent-strong);
  font-size: 0.78rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
.hero-text {
  max-width: 680px;
  margin: 1.4rem 0 0;
  color: var(--muted);
  font-size: clamp(1.1rem, 2vw, 1.35rem);
}
.hero-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 2rem;
}
.button {
  display: inline-flex;
  min-height: 2.75rem;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 0.72rem 1rem;
  background: var(--surface);
  color: var(--text);
  font-weight: 700;
  text-decoration: none;
  box-shadow: 0 1px 0 rgba(0, 0, 0, 0.03);
  transition: color 160ms ease, border-color 160ms ease, background-color 160ms ease, transform 160ms ease;
}
.button.primary {
  border-color: var(--accent-strong);
  background: var(--accent-strong);
  color: #ffffff;
}
.button:hover { transform: translateY(-1px); }
.hero-side { display: grid; gap: 1rem; align-self: center; }
.hero-visual {
  aspect-ratio: 13 / 9;
  overflow: hidden;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--surface);
  box-shadow: var(--shadow);
}
.hero-visual svg { display: block; width: 100%; height: 100%; }
.visual-bg { fill: var(--surface); }
.visual-grid { opacity: 0.5; }
.hero-visual pattern path {
  fill: none;
  stroke: var(--line);
  stroke-width: 1;
}
.visual-circuit {
  fill: none;
  stroke: var(--accent-strong);
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 6;
}
.visual-circuit circle, .visual-circuit rect { fill: var(--surface); }
.visual-labels {
  fill: var(--muted);
  font-family: "SFMono-Regular", Consolas, "Liberation Mono", monospace;
  font-size: 16px;
  font-weight: 800;
  letter-spacing: 0;
}
.focus-panel, .search-panel {
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 1.4rem;
  background: var(--surface);
  box-shadow: var(--shadow);
}
.focus-panel h2 { margin: 0 0 1rem; font-size: 1rem; }
.focus-panel ul {
  display: grid;
  gap: 0.85rem;
  margin: 0;
  padding-left: 1.1rem;
  color: var(--muted);
}
.section-heading { max-width: 760px; margin-bottom: 1.5rem; }
.section-heading h2, .doc-header h1 {
  margin: 0;
  font-size: clamp(2rem, 5vw, 3.2rem);
  line-height: 1.05;
  letter-spacing: 0;
}
.section-heading p { color: var(--muted); }
.project-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1rem;
}
.project-card {
  display: flex;
  min-height: 330px;
  flex-direction: column;
  justify-content: space-between;
  gap: 1.25rem;
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 1.25rem;
  background: var(--surface);
  box-shadow: var(--shadow-soft);
  transition: border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease;
}
.project-card:hover, .project-card:focus-within {
  border-color: color-mix(in srgb, var(--accent) 45%, var(--line));
  box-shadow: var(--shadow);
  transform: translateY(-2px);
}
.project-card h3, .package-row h3 {
  margin: 0 0 0.6rem;
  font-size: 1.15rem;
  line-height: 1.25;
}
.project-card p, .package-row p {
  margin: 0;
  color: var(--muted);
}
.tags, .badges {
  display: flex;
  flex-wrap: wrap;
  gap: 0.45rem;
}
.tags span, .badges span {
  border: 1px solid var(--line);
  border-radius: 999px;
  padding: 0.22rem 0.55rem;
  background: var(--surface-muted);
  color: var(--muted);
  font-size: 0.78rem;
  font-weight: 700;
}
.card-links {
  display: flex;
  flex-wrap: wrap;
  gap: 0.65rem;
  border-top: 1px solid var(--line);
  padding-top: 1rem;
}
.card-links a, .package-row a, .link-panel a {
  color: var(--accent-strong);
  font-weight: 800;
  text-decoration: none;
}
.card-links a::after, .package-row a::after, .link-panel a::after { content: " ->"; }
.package-list { display: grid; gap: 0.75rem; }
.package-row {
  display: grid;
  grid-template-columns: minmax(220px, 1fr) minmax(160px, 0.45fr) auto;
  align-items: center;
  gap: 1rem;
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 1rem;
  background: var(--surface);
  transition: border-color 160ms ease, box-shadow 160ms ease;
}
.package-row:focus-within, .package-row:hover {
  border-color: color-mix(in srgb, var(--accent) 45%, var(--line));
  box-shadow: var(--shadow-soft);
}
.figure-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1rem;
}
.figure-card {
  margin: 0;
  border: 1px solid var(--line);
  border-radius: 8px;
  overflow: hidden;
  background: var(--surface);
  box-shadow: var(--shadow-soft);
}
.figure-card img {
  display: block;
  width: 100%;
  height: auto;
  background: #ffffff;
}
.figure-card figcaption {
  border-top: 1px solid var(--line);
  padding: 0.85rem 1rem;
  color: var(--muted);
  font-weight: 700;
}
.split-section {
  display: grid;
  grid-template-columns: minmax(260px, 0.8fr) minmax(0, 1.2fr);
  gap: clamp(1.5rem, 5vw, 4rem);
}
.link-panel { display: grid; gap: 0.85rem; }
.search-panel label {
  display: block;
  margin-bottom: 0.5rem;
  color: var(--muted);
  font-weight: 800;
}
.search-panel input {
  width: 100%;
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 0.85rem 1rem;
  background: var(--surface-muted);
  color: var(--text);
  font: inherit;
}
.search-results {
  display: grid;
  gap: 0.7rem;
  margin-top: 1rem;
}
.search-result {
  display: grid;
  gap: 0.2rem;
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 0.85rem 1rem;
  background: var(--surface);
  text-decoration: none;
}
.search-result span { color: var(--muted); }
.doc-layout { max-width: 920px; }
.doc-header {
  border-bottom: 1px solid var(--line);
  padding-bottom: 1.5rem;
  margin-bottom: 1.5rem;
}
.markdown-body {
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: clamp(1rem, 4vw, 2rem);
  background: var(--surface);
  box-shadow: var(--shadow-soft);
}
.markdown-body h1, .markdown-body h2, .markdown-body h3 {
  line-height: 1.2;
  letter-spacing: 0;
}
.markdown-body h2 {
  border-top: 1px solid var(--line);
  padding-top: 1.5rem;
  margin-top: 2rem;
}
.markdown-body img {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
}
pre {
  overflow-x: auto;
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 1rem;
  background: var(--code-bg);
}
code {
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 0.12rem 0.35rem;
  background: var(--code-bg);
  font-family: "SFMono-Regular", Consolas, "Liberation Mono", monospace;
  font-size: 0.9em;
}
pre code {
  border: 0;
  padding: 0;
  background: transparent;
}
.table-wrap {
  overflow-x: auto;
  margin: 1rem 0;
}
table {
  width: 100%;
  border-collapse: collapse;
  border: 1px solid var(--line);
  background: var(--surface);
}
th, td {
  border-bottom: 1px solid var(--line);
  padding: 0.65rem 0.75rem;
  text-align: left;
  vertical-align: top;
}
th {
  background: var(--surface-muted);
  color: var(--accent-strong);
}
.site-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 2rem clamp(1rem, 4vw, 3rem);
  border-top: 1px solid var(--line);
  color: var(--muted);
}
.site-footer a {
  font-weight: 700;
  text-decoration: none;
}
@media (max-width: 880px) {
  .hero, .split-section { grid-template-columns: 1fr; }
  .hero { min-height: auto; }
  .hero-side { grid-template-columns: minmax(0, 1fr) minmax(280px, 0.8fr); align-items: stretch; }
  .project-grid, .figure-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .package-row { grid-template-columns: 1fr; }
}
@media (max-width: 620px) {
  .site-header { align-items: flex-start; flex-direction: column; gap: 0.75rem; }
  .nav-links { justify-content: flex-start; }
  .section { width: min(100% - 1rem, 1120px); padding: clamp(2.5rem, 12vw, 4rem) 0; }
  .hero-copy h1 { font-size: clamp(3.2rem, 18vw, 4.8rem); }
  .project-grid, .figure-grid, .hero-side { grid-template-columns: 1fr; }
  .project-card { min-height: 0; }
  .button { width: 100%; }
  .hero-actions { gap: 0.6rem; }
  .site-footer { align-items: flex-start; flex-direction: column; }
}
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    scroll-behavior: auto !important;
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
  }
  .button:hover, .project-card:hover, .project-card:focus-within { transform: none; }
}
""".strip()


def main() -> None:
    clean_site()
    copy_static_assets()
    search_docs = build_doc_pages()
    search_docs.append(build_api_page())
    write_assets(search_docs)
    build_index()


if __name__ == "__main__":
    main()

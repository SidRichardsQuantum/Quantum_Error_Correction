# Roadmap

This roadmap keeps the project focused on educational quantum error-correction implementations that are easy to run in GNU Octave.

## Near Term

- Keep the generic surface-layout decoder benchmarks reproducible for `d = 3`, `d = 5`, and `d = 7`.
- Add broader regression tests for decoder edge cases beyond the representative higher-weight patterns already covered.
- Expand generated result summaries when new figures, code families, or decoder baselines are added.
- Keep GitHub Pages output synchronized with the README, docs, and API source reference.

## Decoder Work

- Extend the MWPM-style surface decoder with richer geometry or an optional Blossom-backed path if the project grows beyond educational code-capacity studies.
- Add optional benchmark knobs only when new scripts need them; the generic surface-layout benchmark already supports trial count, seed, physical error range, distances, and decoder list.
- Keep documenting where each decoder is exact, heuristic, or only a teaching model.

## Modeling Work

- Extend noisy-syndrome examples with more explicit detector-history outputs.
- Keep circuit-level prototypes compact unless a full stabilizer-circuit simulator is added.
- Avoid presenting educational code-capacity models as calibrated threshold simulations.

## Release Polish

- Tag small releases when examples, tests, generated figures, and Pages output are in sync.
- Keep `CITATION.cff`, README citation text, and docs metadata aligned.

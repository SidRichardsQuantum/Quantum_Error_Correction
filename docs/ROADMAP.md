# Roadmap

This roadmap keeps the project focused on educational quantum error-correction implementations that are easy to run in GNU Octave.

## Near Term

- Keep the generic surface-layout decoder benchmarks reproducible for `d = 3`, `d = 5`, and `d = 7`.
- Add more regression tests for decoder edge cases and representative higher-weight error patterns.
- Expand generated result summaries when new figures or code families are added.
- Keep GitHub Pages output synchronized with the README, docs, and API source reference.

## Decoder Work

- Compare the current bounded-lookup plus peeling decoder against a clearer graph-matching baseline.
- Add optional benchmark knobs for trial count, seed, and plotted physical error range.
- Document where each decoder is exact, heuristic, or only a teaching model.

## Modeling Work

- Extend noisy-syndrome examples with more explicit detector-history outputs.
- Keep circuit-level prototypes compact unless a full stabilizer-circuit simulator is added.
- Avoid presenting educational code-capacity models as calibrated threshold simulations.

## Release Polish

- Tag small releases when examples, tests, generated figures, and Pages output are in sync.
- Keep `CITATION.cff`, README citation text, and docs metadata aligned.

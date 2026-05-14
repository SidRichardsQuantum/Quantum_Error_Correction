OCTAVE ?= octave --no-gui
PYTHON ?= python3

.PHONY: test examples report images plots site validate

test:
	$(OCTAVE) tests/run_all_tests.m

examples:
	$(OCTAVE) examples/run_text_examples.m

report:
	$(OCTAVE) examples/generate_simulation_report.m

images:
	$(OCTAVE) examples/check_generated_images.m

plots:
	$(OCTAVE) examples/run_all_plots.m

site:
	$(PYTHON) tools/build_pages_site.py

validate: test examples report images

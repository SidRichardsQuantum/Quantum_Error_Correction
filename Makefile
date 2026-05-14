OCTAVE ?= octave --no-gui
PYTHON ?= python3

.PHONY: test examples report images plots site check-links package validate

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

check-links: site
	$(PYTHON) tools/check_site_links.py

package:
	$(PYTHON) tools/build_octave_package.py

validate: test examples report images

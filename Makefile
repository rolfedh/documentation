## Generate the website in docs/

# Parameters
BROWSE ?= index.html

# Commands
	ASCIIDOCTOR=asciidoctor --failure-level=WARN \
		-a icons=font -a nofooter \
		-a stylesheet=$(PWD)/css/asciidoctor.css
DOT=dot -Tsvg
LINKCHECKER=linkchecker --anchors --check-html --check-css --check-extern --timeout=5

rebuild: clean all
	@echo "Clean rebuild, you can commit the updated site."

all: check

check: docs
	$(LINKCHECKER) docs/index.html

browse: docs
	nohup xdg-open docs/$(BROWSE) &> /dev/null ; sleep 1

clean:
	rm -rf docs
	$(MAKE) -C src/data_model clean

# Sources
ADOCS=$(shell find src -name '*.adoc' | fgrep -v .part.adoc)
DOTS=$(shell find src -name '*.dot')

# Generated output
HTMLS=$(patsubst src/%.adoc,docs/%.html,$(ADOCS))
SVGS=$(patsubst src/%.dot,docs/%.svg,$(DOTS))

docs: $(HTMLS) $(SVGS) $(PNG_DOCS)

docs/%/index.html: src/%/*.adoc

docs/%.html: src/%.adoc $(MAKEFILE)
	@mkdir -p $(dir $@)
	$(ASCIIDOCTOR) -o $@ $<

docs/%.svg: src/%.dot
	@mkdir -p $(dir $@)
	$(DOT) $< -o $@

docs/%.png: src/%.png
	@mkdir -p $(dir $@)
	cp $< $@

# Generate data model adoc fragments needed by adoc documents.
src/data_model/private/data_model.adoc src/data_model/public/data_model.adoc: force
	$(MAKE) -C src/data_model all
.PHONY: force

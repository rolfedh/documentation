## Generate the website in docs/

# Commands
ASCIIDOCTOR=asciidoctor -a icons=font -a --failure-level=WARN
DOT=dot -Tsvg
LINKCHECKER=linkchecker --anchors --check-html --check-css --check-extern --timeout=5
SHOW_PRIVATE=1

rebuild: clean all

all: check

check: docs
	$(LINKCHECKER) docs/index.html

browse: docs
	nohup xdg-open docs/index.html &> /dev/null ; sleep 1

clean:
	rm -rf docs
	$(MAKE) -C src/data_model clean

# Sources
ADOCS=$(shell find src -name '*.adoc')
DOTS=$(shell find src -name '*.dot')

# Generated output
HTMLS=$(patsubst src/%.adoc,docs/%.html,$(ADOCS))
SVGS=$(patsubst src/%.dot,docs/%.svg,$(DOTS))

docs: $(HTMLS) $(SVGS)

docs/%.html: src/%.adoc
	@mkdir -p $(dir $@)
	$(ASCIIDOCTOR) -a icons=font -o $@ $<

docs/%.svg: src/%.dot
	@mkdir -p $(dir $@)
	$(DOT) $< -o $@

# Generate data model adoc fragments needed by src/data_model/index.adoc
src/data_model/index.adoc: force
	$(MAKE) -C src/data_model all

.PHONY: force

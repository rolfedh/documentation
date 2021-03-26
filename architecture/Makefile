# Makefile to generate diagrams and HTML from dot and adoc.

# Source files
ADOC=$(wildcard *.adoc)
DOT=$(wildcard *.dot)

# Generated files
HTML=$(patsubst %.adoc, %.html, $(ADOC))
SVG=$(patsubst %.dot, %.svg, $(DOT))

all: content check

content: $(SVG) $(HTML)

%.html: %.adoc
	asciidoctor $<

%.svg: %.dot
	dot -Tsvg $< -o $@

view: content
	nohup xdg-open README.html &> /dev/null & disown

check: $(ADOC)
ifeq (, $(shell which asciidoc-link-check))
	echo "missing link checker, try: npm install -g asciidoc-link-check"
	false
else
	asciidoc-link-check -q $^
endif

clean:
	rm -rf $(HTML) $(SVG)


# Generate data model adoc fragments from YAML definitions.

GOMPLATE=gomplate

YAMLS=$(wildcard *.yaml)
ADOCS=$(patsubst %.yaml,adoc/%.adoc,$(YAMLS))
TEMPLATE=data_model.adoc.gotmpl

all: $(ADOCS)

clean:
	rm -rf adoc

adoc/%.adoc: %.yaml $(TEMPLATE)
	@mkdir -p $(dir $@)
	$(GOMPLATE) -c.=$< -f $(TEMPLATE) > $@
	@touch index.adoc

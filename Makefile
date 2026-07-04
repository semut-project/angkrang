APP=angkrang
VERSION := $(shell tr -d '\n' < VERSION)
DIST=$(APP)-$(VERSION)

.PHONY: package clean release

package: clean
	mkdir -p $(DIST)
	for path in bin docker shared config scripts assets docs install.sh README.md LICENSE VERSION MANIFEST.txt; do \
	  if [ -e "$$path" ]; then \
	    cp -r "$$path" "$(DIST)/"; \
	  fi; \
	done
	chmod +x $(DIST)/install.sh
	tar -czf $(DIST).tar.gz $(DIST)
	rm -rf $(DIST)

clean:
	rm -rf $(DIST) $(DIST).tar.gz

release: package

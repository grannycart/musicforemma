# Note: modified from original source from maintainer
BUILD = built-files
BOOKNAME = MusicForEmma
# This BOOKNAME variable is the output file name, not the title
TITLE = title.txt
METADATA = metadata.xml
# Metadata is a part of the epub standard, even if it repeats stuff in the title file
CHAPTERS = MusicForEmma.md
# I believe separate chapter files are just separated by a space --- see maintainer version to check
# TOC = --toc --toc-depth=1 # Not using toc
# COVER_IMAGE = cover/cover-Prospect-temp.png
# I think the cover pic works better if you use a .png or a .jpg
# But upload a .tif to Amazon's cover pic
LATEX_CLASS = article
# This document is fairly simple, so 'article' works well.
CSS = epub.css
# This corresponds to the --css switch in the epub pandoc command
# It is critically important because it centers the titles and separators among other things. It vastly improves the epub output.
# It is not included in the original maintainer's version.
# The -css switch doesn't seem to have an impact on html or pdf output.

all: book

book: epub html pdf latex txt md 

clean:
	rm -r $(BUILD)

epub: $(BUILD)/epub/$(BOOKNAME).epub

html: $(BUILD)/html/$(BOOKNAME).html

pdf: $(BUILD)/pdf/$(BOOKNAME).pdf

latex: $(BUILD)/latex/$(BOOKNAME).tex

txt: $(BUILD)/txt/$(BOOKNAME).txt

md: $(BUILD)/markdown/$(BOOKNAME).md

$(BUILD)/epub/$(BOOKNAME).epub: $(TITLE) $(CHAPTERS)
	mkdir -p $(BUILD)/epub
# Note: if you look at the original source from the maintainer for this ebook compiler they have a -S in these lines. That switch is deprecated in modern pandoc. I added the --from markdown+smart instead to the pandoc compile lines.
# You need to add this switch and uncomment the cover file line at the top if you want a cover image: --epub-cover-image=$(COVER_IMAGE)
	pandoc --css=$(CSS) --from markdown+smart --epub-metadata=$(METADATA) -o $@ $^

$(BUILD)/html/$(BOOKNAME).html: $(TITLE) $(CHAPTERS)
	mkdir -p $(BUILD)/html
	pandoc -s --from markdown+smart --to=html5 -o $@ $^

$(BUILD)/pdf/$(BOOKNAME).pdf: $(TITLE) $(CHAPTERS)
	mkdir $(BUILD)/pdf
#	Below with some latex options (-V) added.
	pandoc -s --from markdown+smart --pdf-engine=xelatex -V documentclass=$(LATEX_CLASS) -V papersize=letter -o $@ $^

$(BUILD)/latex/$(BOOKNAME).tex: $(TITLE) $(CHAPTERS)
	mkdir $(BUILD)/latex
#	Below with some latex options (-V) added.
	pandoc -s --from markdown+smart -V documentclass=$(LATEX_CLASS) -V papersize=letter -o $@ $^

$(BUILD)/txt/$(BOOKNAME).txt: $(TITLE) $(CHAPTERS)
	mkdir -p $(BUILD)/txt
	pandoc -s --from markdown+smart -o $@ $^

$(BUILD)/markdown/$(BOOKNAME).md: $(TITLE) $(CHAPTERS)
	mkdir -p $(BUILD)/markdown
# markdown target just turns the chapters into a single, cleaned up md file --- good for github pages.
	pandoc -s $(TOC) --from markdown+smart --to=markdown -o $@ $^


.PHONY: all book clean epub html pdf latex txt md

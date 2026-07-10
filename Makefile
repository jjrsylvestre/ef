# recursive wildcard, from answers to
# https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
#
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SOURCES = $(call rwildcard,src,*.ptx *.tex)

BRANDLOGO=AUG-Colour.png
ROOTDOCNAME=book
SERVEPORT=8081
BUILDDIR=${XDG_RUNTIME_DIR}/pretext/EF
#PRETEXT=/opt/pretext/pretext/pretext
#PRETEXT=./pretext/pretext/pretext
PRETEXTDIR=./pretext
ROOT_XMLID=book-elementary-foundations
REMOTE_LOCATION=
STIXFONTS_VERSION := $(shell cat stixfonts_version.txt)

.PHONY: ptx validate-xml validate-ptx \
  html html-images html-fonts html-all html-serve \
  clean ptx-clean html-clean html-images-clean \
  help list

log_error = (>&2 echo ">>>> $1" && exit 1)

list: help
help:
	@echo "== TARGETS ==============="
	@echo "> validate-xml       : Check for XML syntax/format errors. (Does not validate against PTX schema.)"
	@echo "> validate-ptx       : Check for PTX schema errors."
	@echo "> html-all           : Perform all steps necessary to create HTML version of the activity set."
	@echo "> html               : Output (only) HTML files containing all worksheets."
	@echo "> html-images        : Create SVG image files to accompany the html output for all worksheets."
	@echo "> html-fonts         : Copy STIX2Text fonts into the HTML build directory."
	@echo "> html-serve         : Fire up a simple Python web server to locally host the HTML output."
	@echo "> html-deploy        : rsync HTML files to a remote server."
	@echo "                       Requires that the REMOTE_LOCATION parameter be set on the command line."
	@echo "> latex              : Output (only) LaTeX file containing all worksheets."
	@echo "> ptx                : Only preprocess source to create a single XML file in PTX format containing all worksheets."
	@echo "> clean              : Remove all output files."
	@echo "> ptx-clean          : Remove preprocessed PTX output."
	@echo "> html-clean         : Remove all HTML output."
	@echo "> html-images-clean  : Remove all accomanying SVG files."
	@echo "== PARAMETERS ============"
	@echo "> BUILDDIR       : Root directory for all output files. [Default: $(BUILDDIR)]"
	@echo "> BRANDLOGO      : Filename of institutional logo. Needs to exist in images/. [Default: $(BRANDLOGO)]"
	@echo "> PRETEXTDIR     : Path to PreTeXt installation."
	@echo "                   [Default: $(PRETEXTDIR)]"
	@echo "> SERVEPORT      : Local port on which to serve HTML output when using the html-serve target. [Default: $(SERVEPORT)]"
	@echo "> REMOTE_LOCATION: Remote path to use as rsync target for HTML output."
	@echo "                   [Default: unset]"


html-all: html html-images

html-deploy: html
	@[ "$(REMOTE_LOCATION)" ] || $(call log_error, "REMOTE_LOCATION not set!")
	@echo "Transferring ${BUILDDIR}/html to ${REMOTE_LOCATION} ..."
	@./scripts/deploy.sh ${BUILDDIR}/html html-deploy.exclude ${REMOTE_LOCATION}

clean: ptx-clean html-clean html-images-clean

ptx-clean:
	@-rm -f ${BUILDDIR}/ptx/.sentinel
	@-rm -f ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
html-clean:
	@-rm -f ${BUILDDIR}/html/.sentinel
	@-rm -f ${BUILDDIR}/html/*.html
	@-rm -f ${BUILDDIR}/html/knowl/*.html
html-images-clean:
	@-rm -f ${BUILDDIR}/html/images/.sentinel
	@-rm -f ${BUILDDIR}/html/images/*.svg
	@-rm -f ${BUILDDIR}/html-image-pdfs/.sentinel
	@-rm -f ${BUILDDIR}/html-image-pdfs/*.pdf

ptx: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx preprocess.xsl
html: ${BUILDDIR}/html/.sentinel html-out.xml html-fonts
html-images: ${BUILDDIR}/html/images/.sentinel
latex: ${BUILDDIR}/latex/${ROOTDOCNAME}.tex

${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx: $(SOURCES) | validate-xml
	@echo "Consolidating document into one PTX file, output will be placed in ${BUILDDIR}/ptx..."
	@mkdir -p ${BUILDDIR}/ptx
	@echo "...calling xsltproc..."
	@xsltproc \
	  --xinclude \
	  --output ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx \
	  ./preprocess.xsl src/${ROOTDOCNAME}.ptx
	@touch ${BUILDDIR}/ptx/.sentinel
	@echo "...DONE"

${BUILDDIR}/html/.sentinel: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "${BUILDDIR}/html/.sentinel"
# ${BUILDDIR}/html/.sentinel: html-fonts ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
# 	@echo "Converting PTX to HTML..."
# 	@-rm -f ${BUILDDIR}/html/.sentinel
# 	@mkdir -p ${BUILDDIR}/html/knowl
# 	@echo "...calling pretext to compile PreTeXt document"
# 	@${PRETEXTDIR}/pretext/pretext \
# 	  --verbose \
# 	  --config pretext.cfg \
# 	  --component all \
# 	  --format html \
# 	  --publisher html-out.xml \
# 	  --parameters \
# 	    html.css.extra ef.css \
# 	  --directory ${BUILDDIR}/html \
# 	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
# 	@echo "...copying css style customizations"
# 	@cp css/ef.css ${BUILDDIR}/html/
# 	@sed -i -e 's/scale: 0\.[0-9]*,/scale: 1.00,/' ${BUILDDIR}/html/*.html
# 	@touch ${BUILDDIR}/html/.sentinel
# 	@echo "...DONE"
# 	@echo "Now call:"
# 	@echo "   make html-images  (to build SVG images)"
# 	@echo "   make html-serve   (to serve the output locally for previewing)"

${BUILDDIR}/html/images/.sentinel: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Generating SVG files for HTML output..."
	@-rm -f ${BUILDDIR}/html/images/.sentinel
	@mkdir -p ${BUILDDIR}/html/images
	@echo "...calling pretext to generate images"
	@echo "...(restricted to ${ROOT_XMLID})"
	@${PRETEXTDIR}/pretext/pretext \
	  --verbose \
	  --config pretext.cfg \
	  --component latex-image \
	  --format svg \
	  --restrict ${ROOT_XMLID} \
	  --directory ${BUILDDIR}/html/images \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "...copying institution logo"
	@-cp images/${BRANDLOGO} ${BUILDDIR}/html/images
	@touch ${BUILDDIR}/html/images/.sentinel
	@echo "...DONE"

${BUILDDIR}/html-image-pdfs/.sentinel: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Generating PDF image files..."
	@-rm -f ${BUILDDIR}/html-image-pdfs/.sentinel
	@mkdir -p ${BUILDDIR}/html-image-pdfs
	@echo "...calling pretext to generate images"
	@echo "...(restricted to ${ROOT_XMLID})"
	@${PRETEXTDIR}/pretext/pretext \
	  --verbose \
	  --component latex-image \
	  --format pdf \
	  --restrict ${ROOT_XMLID} \
	  --directory ${BUILDDIR}/html-image-pdfs \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@touch ${BUILDDIR}/html-image-pdfs/.sentinel
	@echo "...DONE"

${BUILDDIR}/latex/${ROOTDOCNAME}.tex: ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "Converting PTX to LATEX..."
	@mkdir -p ${BUILDDIR}/latex
	@echo "...calling pretext to compile PreTeXt document"
	@${PRETEXT} \
	  --XSL style-latex.xsl \
	  --component all \
	  --format latex \
	  --publisher latex-out.xml \
	  --directory ${BUILDDIR}/latex \
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx
	@echo "...applying adjustments from ./make.d/latex/"
	@./make.d/latex/fourier-font.sh ${BUILDDIR}/latex/${ROOTDOCNAME}.tex
	@./make.d/latex/page-breaks.sh ${BUILDDIR}/latex/${ROOTDOCNAME}.tex
	@echo "...DONE"

html-fonts: ${BUILDDIR}/html/fonts/.sentinel

${BUILDDIR}/html/fonts/.sentinel:
	@echo "Copying STIX2 fonts..."
	@mkdir -p ${BUILDDIR}/html/fonts
	@./scripts/unpack-fonts.sh ${BUILDDIR}/html/fonts ${STIXFONTS_VERSION}
	@touch ${BUILDDIR}/html/fonts/.sentinel

html-serve:
	@./scripts/serve.py ${BUILDDIR}/html $(SERVEPORT) 2>/dev/null

validate-xml: $(SOURCES)
	@echo "Validating xml..."
	@xmllint --xinclude src/${ROOTDOCNAME}.ptx | xmllint --noout -
	@echo "...DONE"

validate-ptx: ptx
	@echo "Validating ptx..."
	@jing ${PRETEXTDIR}/schema/pretext.rng ${BUILDDIR}/ptx/${ROOTDOCNAME}.ptx |\
	  grep -v \
	    -e "element \"worksheet\" not allowed anywhere" \
	    -e "attribute \"xml:base\" not allowed here" >\
	  ${BUILDDIR}/ptx/${ROOTDOCNAME}-schema-errors.txt
	@echo "...DONE"

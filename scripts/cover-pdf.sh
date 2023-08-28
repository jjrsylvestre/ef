#!/bin/sh

cat ${1} | inkscape --pipe --export-filename=${1}.pdf

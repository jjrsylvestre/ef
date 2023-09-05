#!/bin/sh

# Current manual page breaks:
#  Section 4.4
#  Section 9.7
#  Section 10.2
#  Section 14.5
#  Section 16.3
#  Section 19.4
sed -i \
  -e '/\\begin{worksheet-section}{Activities}{Activities}{}{Activities}{}{}{worksheet-activities-pred-logic}/ s|^|\\newpage\n|' \
  -e '/\\begin{sectionptx}{Section}{Sets of sets}{}{Sets of sets}{}{}{section-section-sets-of-sets}/ s|^|\\newpage\n|' \
  -e '/\\begin{sectionptx}{Section}{Properties of functions}{}{Properties of functions}{}{}{section-section-funcs-properties}/ s|^|\\newpage\n|' \
  -e '/\\begin{worksheet-section}{Activities}{Activities}{}{Activities}{}{}{worksheet-activities-graphs}/ s|^|\\newpage\n|' \
  -e '/\\begin{sectionptx}{Section}{Identifying trees}{}{Identifying trees}{}{}{section-section-trees-identifying}/ s|^|\\newpage\n|' \
  -e '/\\begin{sectionptx}{Section}{Total orders}{}{Total orders}{}{}{section-section-partial-orders-total}/ s|^|\\newpage\n|' \
  ${1}

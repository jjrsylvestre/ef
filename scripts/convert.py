#!/usr/bin/python

import sys

for file in sys.argv[1:]:
	with open(file,'r') as input, open(file[:-3] + 'xml','w') as output:
		file_content = input\
			.read()\
			.replace("\\jparnoi","<p>")\
			.replace("\\jpar","<p>")\
			.replace("\\lecskip","")\
			.replace("``","<q>")\
			.replace("''","</q>")\
			.replace("\\ie","<ie />")\
			.replace("\\eg","<eg />")\
			.replace("\\dots ","<ellipsis /> ")\
			.replace("\\neg","\\lgcnot")\
			.replace("\\wedge","\\lgcand")\
			.replace("\\vee","\\lgcor")\
			.replace("\\cond","\\lgccond")\
			.replace("\\bicond","\\lgcbicond")\
			.replace("\\emph{","<em>")\
			.replace("\\inlinedef{","<term>")\
			.replace("\\inlinedefnoidx{","<term>")\
			.replace("\\[","<me>")\
			.replace("\\]","</me>")\
			.replace("\\begin{enumerate}","<ol>")\
			.replace("\\end{enumerate}","</ol>")\
			.replace("\\begin{lecsubexercises}","<ol>")\
			.replace("\\end{lecsubexercises}","</ol>")\
			.replace("\\begin{itemize}","<ul>")\
			.replace("\\end{itemize}","</ul>")\
			.replace("\\begin{description}","<dl>")\
			.replace("\\end{description}","</dl>")\
			.replace("\\begin{proc}","<identity>")\
			.replace("\\end{proc}","</identity>")\
			.replace("\\begin{test}","<claim>")\
			.replace("\\end{test}","</claim>")\
			.replace("\\begin{exmp}","<example>")\
			.replace("\\end{exmp}","</example>")\
			.replace("\\begin{exmps}","<example><p><ol>")\
			.replace("\\end{exmps}","</ol></p></example>")\
			.replace("\\begin{wexmp}","<problem> <!-- worked example -->\n<statement><p>")\
			.replace("\\end{wexmp}","</p></statement>\n</problem>")\
			.replace("\\begin{numthm}","<theorem>")\
			.replace("\\end{numthm}","</theorem>")\
			.replace("\\begin{numprop}","<proposition>")\
			.replace("\\end{numprop}","</proposition>")\
			.replace("\\begin{numlem}","<lemma>")\
			.replace("\\end{numlem}","</lemma>")\
			.replace("\\begin{numcor}","<corollary>")\
			.replace("\\end{numcor}","</corollary>")\
			.replace("\\begin{nonumthm}","<theorem>")\
			.replace("\\end{nonumthm}","</theorem>")\
			.replace("\\begin{nonumprop}","<proposition>")\
			.replace("\\end{nonumprop}","</proposition>")\
			.replace("\\begin{nonumlem}","<lemma>")\
			.replace("\\end{nonumlem}","</lemma>")\
			.replace("\\begin{nonumcor}","<corollary>")\
			.replace("\\end{nonumcor}","</corollary>")\
			.replace("\\begin{fact}","<fact>")\
			.replace("\\end{fact}","</fact>")\
			.replace("\\begin{proof}","<proof><p>")\
			.replace("\\end{proof}","</p></proof>")\
			.replace("\\begin{prfidea}","<proof><title>Proof idea</title><p>")\
			.replace("\\end{prfidea}","</p></proof>")\
			.replace("\\begin{proofof}","<proof><p>")\
			.replace("\\end{proofof}","</p></proof>")\
			.replace("\\begin{goal}","<heuristic><statement><p> <!-- heuristic has been hijacked to \"Goal\" -->")\
			.replace("\\end{goal}","</p></statement></heuristic>")\
			.replace("\\begin{quest}","<question><statement><p>")\
			.replace("\\end{quest}","</p></statement></question>")\
			.replace("\\begin{note}","<note><p>")\
			.replace("\\end{note}","</p></note>")\
			.replace("\\begin{remark}","<remark><p>")\
			.replace("\\end{remark}","</p></remark>")\
			.replace("\\begin{hint}","<hint><p>")\
			.replace("\\end{hint}","</p></hint>")\
			.replace("\\begin{hintnb}","<hint><p>")\
			.replace("\\end{hintnb}","</p></hint>")\
			.replace("\\begin{warn}","<warning><p>")\
			.replace("\\end{warn}","</p></warning>")\
			.replace("\\begin{careful}","\n</p>\n<aside><title>Careful</title><p>\n")\
			.replace("\\end{careful}","\n</p></aside>\n")\
			.replace("\\begin{tyu}","<exercise><p>")\
			.replace("\\end{tyu}","</p></exercise>")\
			.replace("\\begin{sol}","<solution><p>")\
			.replace("\\end{sol}","</p></solution>")\
			.replace("\\begin{altsol}","<solution><title>Alternative solution</title><p>")\
			.replace("\\end{altsol}","</p></solution>")\
			.replace("\\begin{align*}","<md><mrow>")\
			.replace("\\end{align*}","</mrow></md>")\
			.replace("\\begin{multline*}","<md><mrow>")\
			.replace("\\end{multline*}","</mrow></md>")\
			.replace("\\chapter{","<chapter xml:id=\"chapter-TODO-TODO-TODO\">\n<title>")\
			.replace("\\firstlecsec{","<section xml:id=\"section-TODO-TODO-TODO\">\n<title>")\
			.replace("\\lecsec{","</section>\n\n<section xml:id=\"section-TODO-TODO-TODO\">\n<title>")\
			.replace("\\subsection*{","<subsection xml:id=\"subsection-TODO-TODO-TODO\">\n<title>")\
			.replace("\\begin{lecdef}","<p><dl><li>\n<title>TODO</title>\n<idx>TODO-USE-TERM</idx>\n<p>")\
			.replace("\\end{lecdef}","</p>\n</li></dl></p>")\
			.replace("\\begin{lecdefnoidx}{","<p><dl><li>\n<title>\n<!-- no idx of term -->\n<p>\n")\
			.replace("\\end{lecdefnoidx}","</p>\n</li></dl></p>")\
			.replace("\\begin{lecentry}{","<p><dl><li>\n<title>\n<notation>\n<usage>\n<description>\n</notation>\n<p>\n")\
			.replace("\\end{lecentry}","</p>\n</li></dl></p>")\
			.replace("\\item","<li>")\
			.replace("\\hsp","")\
			.replace("\\medhsp","")\
			.replace("\\smhsp","")\
			.split('$')
		while len(file_content) > 1:
			output.write(file_content.pop(0))
			output.write("<m>")
			output.write(file_content.pop(0))
			output.write("</m>")
		if len(file_content) == 1:
			output.write(file_content.pop(0))
		output.close()

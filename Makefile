slides:
	pandoc -t html5 --template=template.html \
		--standalone --section-divs \
		--variable transition="linear" \
		--variable theme="black" \
		-H script.html \
		README.md -o slides.html

reload:
	make slides
	chromereload slides

devel:
	commando -p cat | grep --line-buffered md | conscript make -s reload

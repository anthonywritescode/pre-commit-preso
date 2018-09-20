all: scss

.PHONY: scss
scss: assets/yelp_reveal.css assets/presentation.css

venv: requirements.txt
	rm -rf venv
	virtualenv venv
	venv/bin/pip install -r requirements.txt

nenv: | venv
	rm -rf nenv
	venv/bin/nodeenv --prebuilt nenv
	. nenv/bin/activate && npm install -g bower

bower_components: bower.json | nenv
	. nenv/bin/activate && bower install

%.css: %.scss bower_components | venv
	venv/bin/pysassc $< $@

clean:
	rm -rf venv nenv bower_components assets/*.css
	find -name '*.pyc' -delete

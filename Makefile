all: compile test

compile:
	mkdir -p ebin
	mkdir -p test/ebin
	erl -make

clean:
	rm -rf ./coverage/*.*
	rm -rf ./ebin/*.*
	rm -rf ./test/ebin/*.*

test: compile
	cp test/src/*.app test/ebin/    
	erl -noshell \
		-pa ebin \
		-pa test/ebin \
		-s test_suite test \
		-s init stop

coverage: compile
	git submodule init lib/coverize
	git submodule update lib/coverize
	make -C lib/coverize
	mkdir -p coverage
	cp test/src/*.app test/ebin/    
	erl -noshell \
		-pa ebin \
		-pa test/ebin \
		-pa lib/coverize/ebin \
		-s eunit_helper run_cover \
		-s init stop

console: compile
	cp test/src/*.app test/ebin/    
	erl -pa ebin \
		-pa test/ebin

#EXPERIMENTAL - Bug in erl_tidy trashes -spec
# {test,true} makes this nondestructive
# change {test,true} to {test,false} for plenty of carnage
# Do not commit the result - it is very wrong
tidy: 
	erl -noshell \
		-eval 'erl_tidy:dir("./src", [{verbose,true},{test,true},{new_guard_tests,true},{no_imports,true},{keep_unused,true},{backups,true}])' \
		-eval 'erl_tidy:dir("./test/src", [{verbose,true},{test,true},{new_guard_tests,true},{no_imports,true},{keep_unused,true},{backups,true}])' \
		-s init stop
	find ./ -name \*.bak -exec rm {} \;


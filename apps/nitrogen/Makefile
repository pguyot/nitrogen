compile:
	@erl -pa ./ebin -make
	@cp src/*.app ./ebin

clean:
	@rm -rf ebin/*.beam
	@rm -rf ./test_ebin/*.beam

compile_test:
	@erl -pa ./test_ebin -make

test: compile
	@erl \
		-noshell \
		-pa ./ebin \
		-pa ./test_ebin \
		-eval 'eunit:test(test_suite)' \
		-s init stop
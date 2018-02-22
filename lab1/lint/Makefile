all:
	cat lint.log

%: %_include.sv
	-rm lint.log nLintLog nLintDB
	@nLint -sort s -out lint.log +incdir+../src -sv $<
	make all

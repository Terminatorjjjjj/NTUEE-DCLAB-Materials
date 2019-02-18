NICOTB=/opt/nicotb/lib/
IRUN=irun

%: %_test.sv $(NICOTB)/cpp/nicotb.so
	GLOG_logtostderr=1 \
	GLOG_minloglevel=1 \
	LD_PRELOAD=/usr/lib/libpython3.6m.so \
	TEST=$(if $(TEST),$(TEST),$@)_test \
	TOPMODULE=$(if $(TOPMODULE),$(TOPMODULE),$@)_test \
	PYTHONPATH=$(NICOTB)/python:. \
	$(IRUN) +access+rw -loadvpi $(NICOTB)/cpp/nicotb.so:VpiBoot \
	+incdir+../src/ \
	+incdir+../include/ \
	$(ARGS) $(NICOTB)/verilog/Utils.sv $<

$(NICOTB)/cpp/nicotb.so:
	make -C $(NICOTB)/cpp/

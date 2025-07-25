VIVADO_LIB_PATH=/opt/Xilinx/2025.1/Vivado/lib
VIVADO_BIN_PATH=/opt/Xilinx/2025.1/Vivado/bin/

XELAB=$(VIVADO_BIN_PATH)/xelab
XVLOG=$(VIVADO_BIN_PATH)/xvlog
XSIM=$(VIVADO_BIN_PATH)/xsim

RANDOM := $(shell bash -c 'echo $$RANDOM')
#RANDOM := 18954

all: compile elab

compile:
	export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(VIVADO_LIB_PATH); \
	$(XVLOG) --relax -L uvm -prj top_vlog.prj

elab:
	export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(VIVADO_LIB_PATH); \
	$(XELAB) --debug typical --relax --mt 8 -cov_db_name cov_db -cov_db_dir coverage -cc_type sbct -L xil_defaultlib -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot top_behav xil_defaultlib.top xil_defaultlib.glbl -log elaborate.log

clean:
	rm -rf xsim.dir RISCAT.sim

simulate:
	export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(VIVADO_LIB_PATH); \
	$(XSIM) top_behav -key Behavioral:sim_1:Functional:top -sv_seed $(RANDOM) -log simulate.log -tclbatch top_sim.tcl

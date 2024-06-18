.PHONY: lab1
lab1:
	make clean
	verilator --build ./PipelineCPU.v ./ALU.v ./ALUCtrl.v ./Control.v \
	  ./DataMemory.v ./ImmGen.v ./InstructionMemory.v ./Mux2to1.v ./PC.v  \
	  ./Register.v ./Adder.v ./BranchCmp.v ./Mux4to2.v \
	   --exe ./example_testbench.cpp -cc --trace -Wall
	./obj_dir/VPipelineCPU

.PHONY: clean
clean:
	rm -rf obj_dir
	rm -f waveform.vcd

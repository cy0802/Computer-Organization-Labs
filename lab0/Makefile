.PHONY: part1
part1:
	make clean
	verilator --build ./part1/fullAdder.v --exe ./part1/testbench.cpp -cc --trace -Wall
	./obj_dir/VfullAdder

.PHONY: part2
part2:
	make clean
	verilator --build ./part2/alu.v ./part2/add_sub_4bit.v ./part2/full_adder.v --exe ./part2/testbench.cpp -cc --trace -Wall
	./obj_dir/Valu

.PHONY: add_sub
add_sub:
	make clean
	verilator --build ./part2/add_sub_4bit.v ./part2/full_adder.v --exe ./part2/t_add_sub.cpp -cc --trace -Wall
	./obj_dir/Vadd_sub_4bit

.PHONY: clean
clean:
	rm -rf obj_dir
	rm -f waveform.vcd

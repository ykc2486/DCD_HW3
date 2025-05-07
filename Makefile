VERILATOR = verilator
FLAG = --trace --binary -j 0 -Wall 
VCD_VIEWER = gtkwave  

SRC = gcd3_tb.v
OUT = Vgcd3_tb
WAVE = waveform.vcd          
DIR = obj_dir

all: compile run

compile:
	$(VERILATOR) $(FLAG) $(SRC)

run:
	./$(DIR)/$(OUT)

view:
	$(VCD_VIEWER) $(WAVE)

clean:
	rm -rf $(DIR) $(WAVE)

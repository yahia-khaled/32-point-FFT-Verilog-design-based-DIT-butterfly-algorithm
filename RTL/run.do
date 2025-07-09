# Proceed with QuestaSim simulation
vlib work
vlog -f sourcefile.txt

# Run simulation with GUI
vsim -voptargs=+acc work.FFT_tb

# Add waves with better organization
add wave -divider "Top Level Signals"
add wave *
add wave -divider "DUT Signals"
add wave -position insertpoint sim:/FFT_tb/DUT/*
add wave -divider "Routing network in"
add wave -position insertpoint sim:/FFT_tb/DUT/NET_1/*
add wave -divider "Routing network out"
add wave -position insertpoint sim:/FFT_tb/DUT/u_Routing_Network_output/*
add wave -divider "MAC Block 0 Signals"
add wave -position insertpoint {sim:/FFT_tb/DUT/genblk2[0]/MAC_ints/*}
add wave -divider "MAC Block 1 Signals"
add wave -position insertpoint {sim:/FFT_tb/DUT/genblk2[1]/MAC_ints/*}

# Configure wave display
configure wave -signalnamewidth 1
configure wave -timelineunits ns

# Run complete simulation
run -all
# timing constraints
create_clock -period 10.000 -name clk_100 [get_ports clk_100]

set_false_path -from [get_clocks zed_audio_clk_48M] -to [get_clocks clk_100]
set_false_path -from [get_clocks clk_100] -to [get_clocks zed_audio_clk_48M]


# 100 mhz clock
set_property PACKAGE_PIN Y9 [get_ports clk_100]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100]

# 24 mhz clock to audio chip
set_property PACKAGE_PIN AB2 [get_ports AC_MCLK]
set_property IOSTANDARD LVCMOS33 [get_ports AC_MCLK]


# I2S transfers audio samples
# i2s bit clock to ADAU1761
set_property PACKAGE_PIN Y8 [get_ports AC_GPIO0]
set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO0]

# i2s bit clock from ADAU1761
set_property PACKAGE_PIN AA7 [get_ports AC_GPIO1]
set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO1]

# i2s bit clock from ADAU1761
set_property PACKAGE_PIN AA6 [get_ports AC_GPIO2]
set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO2]

# i2s l/r 48 khz toggling signal from ADAU1761 (sample clock)
set_property PACKAGE_PIN Y6 [get_ports AC_GPIO3]
set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO3]


# I2C Data Interface to ADAU1761 (for configuration)
set_property PACKAGE_PIN AB4 [get_ports AC_SCK]
set_property IOSTANDARD LVCMOS33 [get_ports AC_SCK]

set_property PACKAGE_PIN AB5 [get_ports AC_SDA]
set_property IOSTANDARD LVCMOS33 [get_ports AC_SDA]

set_property PACKAGE_PIN AB1 [get_ports AC_ADR0]
set_property IOSTANDARD LVCMOS33 [get_ports AC_ADR0]

set_property PACKAGE_PIN Y5 [get_ports AC_ADR1]
set_property IOSTANDARD LVCMOS33 [get_ports AC_ADR1]


#Bank13
set_property PACKAGE_PIN AA8 [get_ports {JA[7]}]
#set_property PACKAGE_PIN AA11 [get_ports {JA2}];  # "JA2"
#set_property PACKAGE_PIN Y10  [get_ports {JA3}];  # "JA3"
#set_property PACKAGE_PIN AA9  [get_ports {Ai}];  # "JA4"
set_property PACKAGE_PIN AB11 [get_ports {JA[4]}]
set_property PACKAGE_PIN AB10 [get_ports {JA[5]}]
set_property PACKAGE_PIN AB9 [get_ports {JA[6]}]

# ----------------------------------------------------------------------------
# OLED Display - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN U10  [get_ports oled_dc];  # "OLED-DC"
set_property PACKAGE_PIN U9   [get_ports oled_res];  # "OLED-RES"
set_property PACKAGE_PIN AB12 [get_ports oled_sclk];  # "OLED-SCLK"
set_property PACKAGE_PIN AA12 [get_ports oled_sdin];  # "OLED-SDIN"
set_property PACKAGE_PIN U11  [get_ports oled_vbat];  # "OLED-VBAT"
set_property PACKAGE_PIN U12  [get_ports oled_vdd];  # "OLED-VDD"

set_property PACKAGE_PIN T22 [get_ports EncO[0]];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports EncO[1]];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports EncO[2]];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports EncO[3]];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports EncO[4]];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports Led[0]];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports Led[1]];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports led7_out];  # "LD7"
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];


set_property PACKAGE_PIN F22 [get_ports {switchO[0]}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {switchO[1]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {switchO[2]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {switchO[3]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {switchO[4]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {switchO[5]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {switchO[6]}];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {switchO[7]}];  # "SW7"


# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN P16 [get_ports {rst}];  # "BTNC"


set_property PACKAGE_PIN T19 [get_ports {memory[0][4]}]
set_property PACKAGE_PIN R18 [get_ports {memory[0][3]}]
set_property PACKAGE_PIN T18 [get_ports {memory[0][2]}]
set_property PACKAGE_PIN R16 [get_ports {memory[0][1]}]
set_property PACKAGE_PIN R15 [get_ports {memory[0][0]}]
set_property PACKAGE_PIN P17 [get_ports {memory[1][4]}]
set_property PACKAGE_PIN P18 [get_ports {memory[1][3]}]
set_property PACKAGE_PIN T16 [get_ports {memory[1][2]}]
set_property PACKAGE_PIN T17 [get_ports {memory[1][1]}]
set_property PACKAGE_PIN R19 [get_ports {memory[1][0]}]
set_property PACKAGE_PIN R21 [get_ports {memory[2][4]}]
set_property PACKAGE_PIN P20 [get_ports {memory[2][3]}]
set_property PACKAGE_PIN P21 [get_ports {memory[2][2]}]
set_property PACKAGE_PIN N15 [get_ports {memory[2][1]}]
set_property PACKAGE_PIN P15 [get_ports {memory[2][0]}]
set_property PACKAGE_PIN M21 [get_ports {memory[3][4]}]
set_property PACKAGE_PIN M22 [get_ports {memory[3][3]}]
set_property PACKAGE_PIN N22 [get_ports {memory[3][2]}]
set_property PACKAGE_PIN P22 [get_ports {memory[3][1]}]
set_property PACKAGE_PIN R20 [get_ports {memory[3][0]}]
set_property PACKAGE_PIN L19 [get_ports {memory[4][4]}]
set_property PACKAGE_PIN M19 [get_ports {memory[4][3]}]
set_property PACKAGE_PIN M20 [get_ports {memory[4][2]}]
set_property PACKAGE_PIN N19 [get_ports {memory[4][1]}]
set_property PACKAGE_PIN N20 [get_ports {memory[4][0]}]
set_property PACKAGE_PIN L21 [get_ports {memory[5][4]}]
set_property PACKAGE_PIN L22 [get_ports {memory[5][3]}]
set_property PACKAGE_PIN K19 [get_ports {memory[5][2]}]
set_property PACKAGE_PIN K20 [get_ports {memory[5][1]}]
set_property PACKAGE_PIN L18 [get_ports {memory[5][0]}]
set_property PACKAGE_PIN K18 [get_ports {memory[6][4]}]
set_property PACKAGE_PIN J21 [get_ports {memory[6][3]}]
set_property PACKAGE_PIN J22 [get_ports {memory[6][2]}]
set_property PACKAGE_PIN J20 [get_ports {memory[6][1]}]
set_property PACKAGE_PIN K21 [get_ports {memory[6][0]}]
set_property PACKAGE_PIN M17 [get_ports {memory[7][4]}]
set_property PACKAGE_PIN N17 [get_ports {memory[7][3]}]
set_property PACKAGE_PIN N18 [get_ports {memory[7][2]}]
set_property PACKAGE_PIN M16 [get_ports {memory[7][1]}]
set_property PACKAGE_PIN J18 [get_ports {memory[7][0]}]


#set_property IOSTANDARD LVCMOS18 [get_ports switch_gain7];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];
# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

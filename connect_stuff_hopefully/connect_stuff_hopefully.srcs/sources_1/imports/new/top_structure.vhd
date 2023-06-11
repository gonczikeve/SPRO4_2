library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package portarray is
    type mem_array is array(0 to 7) of integer range -12 to 12;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.portarray.ALL;

entity top_structure_for_oled_and_stuff is

port (      clk         : in std_logic;
            rst         : in std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic;            
            JA : in STD_LOGIC_VECTOR (7 downto 4);  	-- the pmod is plugged in to the lower row of connector JA
			Led: out STD_LOGIC_VECTOR (1 downto 0);		-- Led indicates the direction the shaft is being rotated 
            EncO : inout std_logic_vector (4 downto 0);
            switchO:in std_logic_vector(7 downto 0);
            memory: buffer mem_array
);

end top_structure_for_oled_and_stuff;

architecture Behavioral15 of top_structure_for_oled_and_stuff is
component PmodENC is 
port (        clk: in std_logic;
              JA : in STD_LOGIC_VECTOR (7 downto 4);  	-- the pmod is plugged in to the lower row of connector JA
			  Led: out STD_LOGIC_VECTOR (1 downto 0);		-- Led indicates the direction the shaft is being rotated 
              EncO : inout std_logic_vector (4 downto 0);
              switchO:in std_logic_vector(7 downto 0);
              memory: buffer mem_array
              );
end component;

component oled_ctrl is
port(
            clk         : in std_logic;
            rst         : in std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic;
            switch:in std_logic_vector(0 to 7);
            memory: in mem_array
);
end component;

begin

encoder: PmodENC port map(
              clk=>clk,
              JA=>JA,   	
			  Led=>Led,		
              EncO=>EncO,
              switchO=>switchO,
              memory=>memory
);

oled_control: oled_ctrl port map(
    clk=>clk,
    rst=>rst,
    oled_sdin=>oled_sdin,
    oled_sclk=>oled_sclk,  
    oled_dc=>oled_dc,
    oled_res=>oled_res,
    oled_vbat=>oled_vbat,
    oled_vdd=>oled_vdd,
    switch=>switchO,
    memory=>memory
);

end Behavioral15;

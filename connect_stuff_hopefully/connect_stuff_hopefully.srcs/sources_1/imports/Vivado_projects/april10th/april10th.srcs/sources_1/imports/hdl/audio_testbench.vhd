----------------------------------------------------------------------------------
-- Testbench for Audiointerface for Zedboard
--
-- Stefan Scholl, DC9ST
-- Microelectronic Systems Design Research Group
-- TU Kaiserslautern
-- 2014
----------------------------------------------------------------------------------
-- This testbench can operate in two different modes:
--
-- 1: sawtooth mode: outputs a simple sawtool signal on l and right headphone output (discards input signals)
-- 2: loopback mode: line in signals are routed to the headphone output 
--
-- choose between the two mode by commenting the code blocks below
--
package portarray is
    type mem_array is array(0 to 7) of integer range -12 to 12;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
use work.portarray.ALL;

entity audio_testbench is
Port ( clk_100  : in    STD_LOGIC; -- 100 mhz master takt 
       AC_ADR0  : out   STD_LOGIC;  -- control signals to ADAU chip
       AC_ADR1  : out   STD_LOGIC;
       AC_GPIO0 : out   STD_LOGIC;  -- I2S MISO
       AC_GPIO1 : in    STD_LOGIC;  -- I2S MOSI
       AC_GPIO2 : in    STD_LOGIC;  -- I2S_bclk
       AC_GPIO3 : in    STD_LOGIC;  -- I2S_LR
       AC_MCLK  : out   STD_LOGIC;
       AC_SCK   : out   STD_LOGIC;
       AC_SDA   : inout STD_LOGIC;
--       switch_gain0: in std_logic;
--       switch_gain1: in std_logic;
--       switch_gain2: in std_logic;
--       switch_gain3: in std_logic;
--       switch_gain4: in std_logic;
--       switch_gain5: in std_logic;
--       switch_gain6: in std_logic;
--       switch_gain7: in std_logic;
--       led0_out: out std_logic;
--       led1_out: out std_logic;
--       led2_out: out std_logic;
--       led3_out: out std_logic;
--       led4_out: out std_logic;
--       led5_out: out std_logic;
--       led6_out: out std_logic;
--       led7_out: out std_logic;
       
       --clk_10mhz:  in std_logic;
       rst         : in std_logic;
       oled_sdin   : out std_logic;
       oled_sclk   : out std_logic;
       oled_dc     : out std_logic;
       oled_res    : out std_logic;
       oled_vbat   : out std_logic;
       oled_vdd    : out std_logic;  
       Led: out STD_LOGIC_VECTOR (1 downto 0);          
       JA : in STD_LOGIC_VECTOR (7 downto 4);  	-- the pmod is plugged in to the lower row of connector JA        Led: out STD_LOGIC_VECTOR (1 downto 0);		-- Led indicates the direction the shaft is being rotated 
       EncO : inout std_logic_vector (4 downto 0);
       switchO:in std_logic_vector(7 downto 0);
       memory: buffer mem_array);
       
end audio_testbench;



architecture Behavioral of audio_testbench is
signal clk_10mhz: std_logic :='0';
component top_structure_for_oled_and_stuff

    port (  clk         : in std_logic;
            rst         : in std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic;            
            JA          :in STD_LOGIC_VECTOR (7 downto 4);  	-- the pmod is plugged in to the lower row of connector JA
			Led          : out STD_LOGIC_VECTOR (1 downto 0);		-- Led indicates the direction the shaft is being rotated 
            EncO        : inout std_logic_vector (4 downto 0);
            switchO     :in std_logic_vector(7 downto 0);
            memory      : buffer mem_array
);
end component;

COMPONENT audio_top
Port ( clk_100  : in    STD_LOGIC; -- 100 mhz input clock 
       AC_ADR0  : out   STD_LOGIC; -- contol signals to audio chip
       AC_ADR1  : out   STD_LOGIC;
       AC_GPIO0 : out   STD_LOGIC;  -- I2S MISO
       AC_GPIO1 : in    STD_LOGIC;  -- I2S MOSI
       AC_GPIO2 : in    STD_LOGIC;  -- I2S_bclk
       AC_GPIO3 : in    STD_LOGIC;  -- I2S_LR
       AC_MCLK  : out   STD_LOGIC;
       AC_SCK   : out   STD_LOGIC;
       AC_SDA   : inout STD_LOGIC;

       hphone_l  : in STD_LOGIC_VECTOR(23 downto 0);
       hphone_l_valid : in std_logic;
       hphone_r  : in STD_LOGIC_VECTOR(23 downto 0);
       hphone_r_valid_dummy : in std_logic;
       
       line_in_l    : out STD_LOGIC_VECTOR(23 downto 0);
       line_in_r    : out STD_LOGIC_VECTOR(23 downto 0);
       
       new_sample : out STD_LOGIC;     -- goes up for 1 clk cycle if new sample is transmitted received
       sample_clk_48k : out std_logic  -- sample clock 
       );
END COMPONENT;

component equalizer_top is
  
  Port ( clock: in std_logic;
  audio_in: in std_logic_vector(23 downto 0):=(others => '0');
  audio_out: out std_logic_vector(23 downto 0);
  new_sample: in std_logic;
  out_valid: out std_logic;
  
--  filter0_debug: out std_logic_vector(23 downto 0);
--  filter1_debug: out std_logic_vector(23 downto 0);
--  mvalid0_debug : out std_logic;
--  mvalid1_debug : out std_logic;
  
  gain0: in std_logic_vector(4 downto 0);
  gain1: in std_logic_vector(4 downto 0);
  gain2: in std_logic_vector(4 downto 0);
  gain3: in std_logic_vector(4 downto 0);
  gain4: in std_logic_vector(4 downto 0);
  gain5: in std_logic_vector(4 downto 0);
  gain6: in std_logic_vector(4 downto 0);
  gain7: in std_logic_vector(4 downto 0));
end component;
   
    signal clk_100_buffered: std_logic;

    signal counter : unsigned (5 downto 0);
    signal hphone_l, hphone_r : std_logic_vector (23 downto 0);
    signal hphone_valid: std_logic;
    signal new_sample : std_logic;
    signal sample_clk_48k: std_logic;
    signal line_in_l, line_in_r : std_logic_vector (23 downto 0);
    signal hphone_dummy: std_logic;
    -- keep signals for tracking them with the Logic Analyzer
    attribute keep : string;
    attribute keep of sample_clk_48k : signal is "true";
    attribute keep of hphone_l : signal is "true";
    attribute keep of hphone_r : signal is "true";
    
    attribute keep of line_in_l : signal is "true";
    attribute keep of line_in_r : signal is "true";
    
    signal gain0: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(0),5));--switchO(0) & switchO(0) & "000";
    signal gain1: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(1),5));--switchO(1) & switchO(1) & "000";
    signal gain2: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(2),5));--switchO(2) & switchO(2) & "000";
    signal gain3: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(3),5));--switchO(3) & switchO(3) & "000";
    signal gain4: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(4),5));--switchO(4) & switchO(4) & "000";
    signal gain5: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(5),5));--switchO(5) & switchO(5) & "000";
    signal gain6: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(6),5));--switchO(6) & switchO(6) & "000";
    signal gain7: std_logic_vector(4 downto 0):= std_logic_vector(to_signed(memory(7),5));--switchO(7) & switchO(7) & "000";
    

begin

gain0 <= std_logic_vector(to_signed(memory(0),5));--switchO(0) & switchO(0) & "000";
gain1 <= std_logic_vector(to_signed(memory(1),5));--switchO(1) & switchO(1) & "000";
gain2 <= std_logic_vector(to_signed(memory(2),5));--switchO(2) & switchO(2) & "000";
gain3 <= std_logic_vector(to_signed(memory(3),5));--switchO(3) & switchO(3) & "000";
gain4 <= std_logic_vector(to_signed(memory(4),5));--switchO(4) & switchO(4) & "000";
gain5 <= std_logic_vector(to_signed(memory(5),5));--switchO(5) & switchO(5) & "000";
gain6 <= std_logic_vector(to_signed(memory(6),5));--switchO(6) & switchO(6) & "000";
gain7 <= std_logic_vector(to_signed(memory(7),5));--switchO(7) & switchO(7) & "000";








oled_and_stuff: top_structure_for_oled_and_stuff port map(
     clk       =>  clk_10mhz,       
     rst       =>  rst,       
     oled_sdin =>  oled_sdin, 
     oled_sclk =>  oled_sclk, 
     oled_dc   =>  oled_dc,   
     oled_res  =>  oled_res,  
     oled_vbat =>  oled_vbat, 
     oled_vdd  =>  oled_vdd  ,
     Led       =>Led,
     JA        =>  JA        ,
     EncO      =>  EncO   ,   
     switchO   =>  switchO ,  
     memory    =>  memory   ); 
    
    

i_audio : audio_top port map (
      clk_100  => clk_100_buffered, 
      AC_ADR0  => AC_ADR0,
      AC_ADR1  => AC_ADR1,
      AC_GPIO0 => AC_GPIO0,
      AC_GPIO1 => AC_GPIO1,
      AC_GPIO2 => AC_GPIO2,
      AC_GPIO3 => AC_GPIO3,
      AC_MCLK  => AC_MCLK,
      AC_SCK   => AC_SCK,
      AC_SDA   => AC_SDA,
      
      hphone_l  => hphone_l,
      hphone_l_valid => hphone_valid,
      hphone_r  => hphone_r,
      hphone_r_valid_dummy => hphone_valid,   --  this valid will be discarded later
      
      line_in_l => line_in_l,  
      line_in_r => line_in_r,

      new_sample => new_sample,
      sample_clk_48k => sample_clk_48k
     
   );
   
   equalizer_left: equalizer_top port map(clock => clk_100,
                                audio_in => line_in_l,
                                audio_out => hphone_l,
                                new_sample => new_sample,
                                out_valid => hphone_valid,
                                gain0 =>gain0,
                                gain1 =>gain1,
                                gain2 =>gain2,
                                gain3 =>gain3,
                                gain4 =>gain4,
                                gain5 =>gain5,
                                gain6 =>gain6,
                                gain7 =>gain7);
                                
    equalizer_right: equalizer_top port map(clock => clk_100,
                                audio_in => line_in_r,
                                audio_out => hphone_r,
                                new_sample => new_sample,
                                out_valid => hphone_dummy,
                                gain0 => gain0,
                                gain1 => gain1,
                                gain2 => gain2,
                                gain3 => gain3,
                                gain4 => gain4,
                                gain5 => gain5,
                                gain6 => gain6,
                                gain7 => gain7);
                                
--    led0_out <= not switch_gain0;
--    led1_out <= not switch_gain1;
--    led2_out <= not switch_gain2;
--    led3_out <= not switch_gain3;
--    led4_out <= not switch_gain4;
--    led5_out <= not switch_gain5;
--    led6_out <= not switch_gain6;
--    led7_out <= not switch_gain7;                           
                                
    

    -- use comments to switch between TEST 1 (sawtooth) and 2 (loopback)

    --------------------------------------------------
    -- TEST 1: output sawtooth signal, discard input data
  --  process (clk_100)
   -- begin
   --     if (clk_100'event and clk_100 = '1') then
            
   --         hphone_valid <= '0';
	--		hphone_l <= (others => '0');
	--		hphone_r <= (others => '0');
            
    --        if new_sample = '1' then
     --           counter <= counter + 1;
                
    --            hphone_valid <= '1';
    --            hphone_l <= std_logic_vector(counter) & "000000000000000000" ;
    --           hphone_r <= std_logic_vector(counter) & "000000000000000000";
     --       end if;
            
   --     end if;
   -- end process;

    -----------------------------------------------------
    -- TEST 2: loopback "line in" data to headphone output
--    process (clk_100)
--    begin
--        if (clk_100'event and clk_100 = '1') then
            
--            if(hphone_valid = '0')then
--                hphone_l <= (others => '0');
--                hphone_r <= (others => '0');
--            end if;
            
--        end if;
--    end process;

    clockdiv:process(clk_100)
        variable counter: integer :=0;
        begin
            if(rising_edge(clk_100)) then
                counter := counter+1;
                if (counter = 5) then
                    counter := 0;
                    clk_10mhz <= not clk_10mhz;
                end if;
            end if;   
    end process;
    -- global clock buffer for the clock signal
    BUFG_inst : BUFG
    port map (
       O => clk_100_buffered,   -- 1-bit output: Clock output
       I => clk_100             -- 1-bit input: Clock input
    );  

end Behavioral;

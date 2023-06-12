----------------------------------------------------------------------------------
-- Company: Group 2
-- Engineer: Keve Gonczi
-- 
-- Create Date: 05/21/2023 11:26:37 PM
-- Design Name: 
-- Module Name: equalizer_top - Behavioral
-- Project Name: SPRO4
-- Target Devices: Zedboard
-- Tool Versions: Vivado 2019.1
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity equalizer_top is
  
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
end equalizer_top;

architecture Behavioral of equalizer_top is
    --FILTER COMPONENTS
    COMPONENT fir_compiler_0
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT fir_compiler_1
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT fir_compiler_2
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT fir_compiler_3
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;
    
    
    COMPONENT fir_compiler_4
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT fir_compiler_5
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT fir_compiler_6
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;

    COMPONENT fir_compiler_7
      PORT (
        aclk : IN STD_LOGIC;
        s_axis_data_tvalid : IN STD_LOGIC;
        s_axis_data_tready : OUT STD_LOGIC;
        s_axis_data_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END COMPONENT;
    ---SIGNALS per filters
    signal filter0_to_gain0: std_logic_vector(23 downto 0):=(others => '0');
    signal filter0_complete: std_logic :='0';
    signal gain0_to_sum: std_logic_vector(23 downto 0):=(others => '0');
    signal mul0_done: std_logic:='0';
    signal tready0:std_logic;
    
    signal filter1_to_gain1: std_logic_vector(23 downto 0):=(others => '0');
    signal filter1_complete: std_logic:='0';
    signal gain1_to_sum: std_logic_vector(23 downto 0 ) := (others => '0');
    signal mul1_done: std_logic:='0';
    signal tready1:std_logic;
    
    signal filter2_to_gain2: std_logic_vector(23 downto 0):=(others => '0');
    signal filter2_complete: std_logic:='0';
    signal gain2_to_sum: std_logic_vector(23 downto 0 ) := (others => '0');
    signal mul2_done: std_logic:='0';
    signal tready2:std_logic;
 
 
    signal filter3_to_gain3: std_logic_vector(23 downto 0):=(others => '0');
    signal filter3_complete: std_logic:='0';
    signal gain3_to_sum: std_logic_vector(23 downto 0 ) := (others => '0');
    signal mul3_done: std_logic:='0';
    signal tready3:std_logic;   
    
    signal filter4_to_gain4: std_logic_vector(23 downto 0):=(others => '0');
    signal filter4_complete: std_logic:='0';
    signal gain4_to_sum: std_logic_vector(23 downto 0 ) := (others => '0');
    signal mul4_done: std_logic:='0';
    signal tready4:std_logic;
    
    signal filter5_to_gain5: std_logic_vector(23 downto 0):=(others => '0');
    signal filter5_complete: std_logic:='0';
    signal gain5_to_sum: std_logic_vector(23 downto 0 ) := (others => '0');
    signal mul5_done: std_logic:='0';
    signal tready5:std_logic;
   
    signal filter6_to_gain6: std_logic_vector(23 downto 0):=(others => '0');
    signal filter6_complete: std_logic:='0';
    signal gain6_to_sum: std_logic_vector(23 downto 0 ) := (others => '0');
    signal mul6_done: std_logic:='0';
    signal tready6:std_logic;
    
    -------------------more signals here
    signal filter7_to_gain7: std_logic_vector(23 downto 0):=(others => '0');
    signal filter7_complete: std_logic :='0';
    signal gain7_to_sum: std_logic_vector(23 downto 0):=(others => '0');
    signal mul7_done: std_logic:='0';
    signal tready7:std_logic;
    
    --misc SIGNALS
    signal sum: signed(26 downto 0):= (others => '0');
    signal state:integer := 0;
begin
    
    
    --instantiations
    filter0 : fir_compiler_0
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready0,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter0_complete,
        m_axis_data_tdata => filter0_to_gain0
      );
    filter1 : fir_compiler_1
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready1,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter1_complete,
        m_axis_data_tdata => filter1_to_gain1
      );
      
      filter2 : fir_compiler_2
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready2,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter2_complete,
        m_axis_data_tdata => filter2_to_gain2
      );
      
      filter3 : fir_compiler_3
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready3,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter3_complete,
        m_axis_data_tdata => filter3_to_gain3
      );
      
      filter4 : fir_compiler_4
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready4,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter4_complete,
        m_axis_data_tdata => filter4_to_gain4
      );
      
      filter5 : fir_compiler_5
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready5,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter5_complete,
        m_axis_data_tdata => filter5_to_gain5
      );

    filter6 : fir_compiler_6
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready6,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter6_complete,
        m_axis_data_tdata => filter6_to_gain6
      );
  
      filter7: fir_compiler_7
      PORT MAP (
        aclk => clock,
        s_axis_data_tvalid => new_sample,
        s_axis_data_tready => tready7,
        s_axis_data_tdata => audio_in,
        m_axis_data_tvalid => filter7_complete,
        m_axis_data_tdata => filter7_to_gain7
      );
  
  
  
  statemachine: process(filter0_complete,clock) 
  
  begin
    if(falling_edge(clock)) then
        if(filter0_complete = '1') then
            --apply gain
            gain0_to_sum <= to_stdlogicvector(to_bitvector(filter0_to_gain0) sra to_integer(signed(gain0)));
            gain1_to_sum <= to_stdlogicvector(to_bitvector(filter1_to_gain1) sra to_integer(signed(gain1)));
            gain2_to_sum <= to_stdlogicvector(to_bitvector(filter2_to_gain2) sra to_integer(signed(gain2)));
            gain3_to_sum <= to_stdlogicvector(to_bitvector(filter3_to_gain3) sra to_integer(signed(gain3)));
            gain4_to_sum <= to_stdlogicvector(to_bitvector(filter4_to_gain4) sra to_integer(signed(gain4)));
            gain5_to_sum <= to_stdlogicvector(to_bitvector(filter5_to_gain5) sra to_integer(signed(gain5)));
            gain6_to_sum <= to_stdlogicvector(to_bitvector(filter6_to_gain6) sra to_integer(signed(gain6)));
            gain7_to_sum <= to_stdlogicvector(to_bitvector(filter7_to_gain7) sra to_integer(signed(gain7)));
            
            state <= 1;
        elsif(state = 1) then
            --combine outputs
            sum <=          signed(gain0_to_sum(23) & gain0_to_sum(23)& gain0_to_sum(23) & gain0_to_sum)
                           +signed(gain1_to_sum(23) & gain1_to_sum(23)& gain1_to_sum(23) & gain1_to_sum)
                           +signed(gain2_to_sum(23) & gain2_to_sum(23)& gain2_to_sum(23) & gain2_to_sum)
                           +signed(gain3_to_sum(23) & gain3_to_sum(23)& gain3_to_sum(23) & gain3_to_sum)
                           +signed(gain4_to_sum(23) & gain4_to_sum(23)& gain4_to_sum(23) & gain4_to_sum)
                           +signed(gain5_to_sum(23) & gain5_to_sum(23)& gain5_to_sum(23) & gain5_to_sum)
                           +signed(gain6_to_sum(23) & gain6_to_sum(23)& gain6_to_sum(23) & gain6_to_sum)
                           +signed(gain7_to_sum(23) & gain7_to_sum(23)& gain7_to_sum(23) & gain7_to_sum);
                           --extend signals with their sign bit to 27 bits, as signed addition does not have carry for some reason. 
                           --Since they were 24 bit wide originally, there will be no carry over the 27th bit
            state <= 2;
        elsif(state =2) then
            audio_out <= std_logic_vector(sum(26 downto 3));--truncate lsbs to get a 24 bit output
            out_valid <= '1';
            state <= 3;
        elsif(state = 3) then
            out_valid <= '0';
            state <= 0;
        end if;
     end if;
  end process statemachine;
  
end Behavioral;



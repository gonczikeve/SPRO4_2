library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.portarray.ALL;


entity PmodENC is
    Port (
			  clk: in std_logic;
              JA : in STD_LOGIC_VECTOR (7 downto 4);  	-- the pmod is plugged in to the lower row of connector JA
			  Led: out STD_LOGIC_VECTOR (1 downto 0);		-- Led indicates the direction the shaft is being rotated 
              EncOut: inout STD_LOGIC_VECTOR (4 downto 0);
              EncO : inout std_logic_vector (4 downto 0);
              switchO:in std_logic_vector(7 downto 0);
              memory: buffer mem_array
			  );
end PmodENC;



architecture Behavioral of PmodENC is
component Debouncer is
	port(
			clk : in  STD_LOGIC;
         Ain : in  STD_LOGIC;
         Bin : in  STD_LOGIC;
			Aout: out STD_LOGIC;
			Bout: out STD_LOGIC
		);
	end component;

component Encoder is
	Port (
					clk: in STD_LOGIC;
					A : in  STD_LOGIC;
					B : in  STD_LOGIC;
					BTN : in  STD_LOGIC;
					switch:in std_logic_vector(0 to 7);
					EncOut: inout STD_LOGIC_VECTOR (4 downto 0);
					EncO : inout std_logic_vector (4 downto 0);
					LED: out STD_LOGIC_VECTOR (1 downto 0);
					memory: buffer mem_array
			  );
	end component;
	
signal AO, BO: std_logic;
--signal LED: STD_LOGIC_VECTOR (1 downto 0);

begin
	
	C0: Debouncer port map ( clk=>clk, Ain=>JA(4), Bin=>JA(5), Aout=> AO, Bout=> BO);
	C1: Encoder port map ( clk=>clk, A=>AO, B=>BO, BTN=>JA(6), EncOut=>EncO, LED=>Led, switch=>switchO, memory=>memory
	);

end Behavioral;


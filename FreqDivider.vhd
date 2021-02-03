library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FreqDivider is
Port (

clk_36mz : in std_logic;
clk_1kz  : out std_logic;
clk_20hz : out std_logic
 );
end FreqDivider;

architecture Behavioral of FreqDivider is

signal counter_1kz  : integer range 0 to 36000 :=0;
signal counter_20hz : integer range 0 to 1800000 :=0;
signal clk_state2 : std_logic;
signal clk_state : std_logic;

begin 

oneKHz_proc: process(clk_36mz) is
begin 
if rising_edge(clk_36mz) then
if counter_1kz = 3000 then
   clk_state <= not (clk_state);
   counter_1kz <= 0;
else 
    counter_1kz <= counter_1kz + 1;
end if; 
end if;  
end process;

twentyHz_proc: process(clk_36mz) is
begin 
if rising_edge(clk_36mz) then
if counter_20hz = 100000 then
   clk_state2 <= not (clk_state2);
   counter_20hz <= 0;
else 
    counter_20hz <= counter_20hz + 1;
end if;  
end if; 
end process;

clk_1kz <= clk_state;
clk_20hz <= clk_state2;
end Behavioral;

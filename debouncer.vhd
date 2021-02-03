library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity debouncer is
port(
Clk        :  in std_logic; -- 1KHz
switch_in  :  in std_logic;
swtich_out :  out std_logic
);
end debouncer;

architecture Behavioral of debouncer is

signal debounced : std_logic;
signal sample : std_logic;
signal sample_t : std_logic;
signal counter: integer range 0 to 250 :=0; -- 250ms

begin

process(Clk)
begin

    if rising_edge(Clk) then
       sample_t <= switch_in;
       sample <= sample_t;
    end if;
    
end process;


process(Clk,sample)
begin

   if rising_edge(Clk) then 
      if sample = '1' then
         counter <= counter + 1;
           if counter = 249 then
               counter <= 249;
               debounced <= sample;   
            end if;
       else
           debounced <= sample;
           counter <= 0;
       end if;             
   end if;

end process;


swtich_out <= debounced;

end Behavioral;

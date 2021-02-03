library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use iEEE.numeric_std.all;

entity vga_contorller is
 port( 
       Clk_36Mhz : in std_logic;
       V_sync : out std_logic;
       H_sync : out std_logic;
       active_region: out std_logic;
       vertical_blank :out std_logic;
       horizontal_blank: out std_logic;
       V_count: out integer;
       H_count: out integer
       );
end entity;

architecture Behavoiral of vga_contorller is

signal H_signal : std_logic;
signal V_signal : std_logic;
signal H_counter : integer range 0 to 1100 :=0;
signal V_counter : integer range 0 to 1000 :=0;
signal active : std_logic;

begin
     
     process(Clk_36Mhz) is
     begin
          if rising_edge(Clk_36Mhz) then
             if H_counter = 1023 then
                H_counter <= 0;
                V_counter <= V_counter + 1;
             else
                H_counter <= H_counter + 1;
             end if;
           if  V_counter = 624 then
               V_counter <= 0;
           end if; 
          end if;    
     end process;
     
    process(H_counter,V_counter)
    begin
          if H_counter > 823 and H_counter < 895 then
              H_signal <= '0';
              else
               H_signal <= '1';
          end if;
          
           if V_counter > 600 and V_counter < 603 then
              V_signal <= '0';
              else
               V_signal <= '1';
          end if;
          
          if V_counter < 600 and H_counter < 800 then
             active_region <= '1';
              active <= '1';
             horizontal_blank <= '0';
             vertical_blank <= '0';            
          elsif H_counter >= 800 and V_counter < 600 then
                 active_region <= '0';
                 active <= '0';
                 horizontal_blank <= '1';
                 vertical_blank <= '0';
          elsif H_counter < 800 and V_counter >= 600 then
                 active_region <= '0';
                 active <= '0';
                 horizontal_blank <= '0';
                 vertical_blank <= '1';
          else
                 active_region <= '0';
                 active <= '0';
                 horizontal_blank <= '1';
                 vertical_blank <= '1';
          end if;                    
                                        
    end process;
     
V_sync <= V_signal;
H_sync <= H_signal;
V_count <= V_counter;
H_count <= H_counter; 

end Behavoiral;






       

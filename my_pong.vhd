


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity my_pong is
port(
     Clk_36megaHz : in std_logic;
     reset_button : in std_logic;
     button_up_p1 : in std_logic;
     button_dn_p1 : in std_logic;
     button_up_p2 : in std_logic;
     button_dn_p2 : in std_logic;
     
     H_sync : out std_logic;
     V_sync : out std_logic;  
     pixel  : out std_logic    
);
end my_pong;

architecture Behavioral of my_pong is

component debouncer is
port(
Clk        :  in std_logic; -- 1KHz
switch_in  :  in std_logic;
swtich_out :  out std_logic
);
end component;

component FreqDivider is
Port (
clk_36mz : in std_logic;
clk_1kz  : out std_logic;
clk_20hz : out std_logic
 );
end component;

component GameControl is
generic(
H_limit : integer := 25
);
Port (
clk_20hz     : in std_logic;
up_p1        : in std_logic;
down_p1      : in std_logic;
up_p2        : in std_logic;
down_p2      : in std_logic;
reset        : in std_logic;
active_region: in std_logic;
H_counter    : in integer;
V_counter    : in integer;
screen       : out std_logic
 );
end component;

component vga_contorller is
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
end component;


signal clk_1k_sig : std_logic;
signal clk_20hz_sig : std_logic;
signal player1_up : std_logic;
signal player1_dn : std_logic;
signal player2_up : std_logic;
signal player2_dn : std_logic;
signal reset : std_logic;
signal active : std_logic;

signal vcount : integer;
signal hcount : integer;

begin

Freq_div : FreqDivider port map
           (
             clk_36mz => Clk_36megaHz ,
             clk_1kz => clk_1k_sig,
             clk_20hz => clk_20hz_sig
           );
           
Up_p1_debounce : debouncer port map
                 (
                   Clk => clk_1k_sig,
                   switch_in => button_up_p1,
                   swtich_out => player1_up
                 );          
Dn_p1_debounce : debouncer port map
                 (
                   Clk => clk_1k_sig,
                   switch_in => button_dn_p1,
                   swtich_out => player1_dn
                 );
Up_p2_debounce : debouncer port map
                 (
                   Clk => clk_1k_sig,
                   switch_in => button_up_p2,
                   swtich_out => player2_up
                 );          
Dn_p2_debounce : debouncer port map
                 (
                   Clk => clk_1k_sig,
                   switch_in => button_dn_p2,
                   swtich_out => player2_dn
                 );               


                  
VGA : vga_contorller port map
      (
         Clk_36Mhz => Clk_36megaHz,
         V_sync => V_sync,
         H_sync => H_sync,
         active_region => active,
         vertical_blank => open,
         horizontal_blank => open,
         V_count => vcount,
         H_count => hcount
      );

GAME : GameControl port map
       (
         clk_20hz => clk_20hz_sig,
         up_p1  => player1_up ,
         down_p1 => player1_dn,
         up_p2 => player2_up,
         down_p2 => player2_dn,
         reset => reset_button,
         active_region => active,
         H_counter => hcount,
         V_counter => vcount,
         screen => pixel      
       );

end Behavioral;

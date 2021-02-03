library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GameControl is
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
end GameControl;

architecture Behavioral of GameControl is


 signal player_one_uplimit : integer range 0 to 600;
 signal player_one_lowlimit : integer range 0 to 600;
 
 signal player_two_uplimit : integer range 0 to 600;
 signal player_two_lowlimit : integer range 0 to 600;
 
 signal left_player : std_logic;
 signal right_player : std_logic;
 signal ball : std_logic;
 
 signal x_cord : integer range 0 to 800;
 signal y_cord : integer range 0 to 800;
 
 signal ball_x_low : integer range 0 to 800;
 signal ball_x_high : integer range 0 to 800;
 signal ball_y_low : integer range 0 to 600;
 signal ball_y_high : integer range 0 to 600;
 
  signal delay : integer range 0  to 201;
  


 type ball_sm is (ball_reset , left_up , left_down , right_up , right_down);
 signal my_ball_sm : ball_sm := ball_reset;
 
begin

player_one_proc: process(up_p1,down_p1,reset,clk_20hz)
                 begin
                 
                      if reset = '0' then
                      
                          player_one_uplimit <= 320;
                          player_one_lowlimit <= 200;
                      elsif up_p1 = '1' and down_p1 = '0' then
                             if rising_edge(clk_20hz) then                              
                                  if player_one_lowlimit = 1 then
                                      player_one_lowlimit <= player_one_lowlimit;
                                      player_one_uplimit <= player_one_uplimit;
				    else
                                         player_one_uplimit <= player_one_uplimit - 1;
                                         player_one_lowlimit <= player_one_lowlimit - 1;
                                  end if;                                
                             end if;    
                      
                      elsif up_p1 = '0' and down_p1 = '1' then
                              if rising_edge(clk_20hz) then                                
                                  if player_one_uplimit = 599 then
                                      player_one_lowlimit <= player_one_lowlimit;
                                      player_one_uplimit <= player_one_uplimit;
                                  else
                                       player_one_uplimit <= player_one_uplimit + 1;
                                       player_one_lowlimit <= player_one_lowlimit + 1;
                                  end if;                                
                             end if; 
                                           
                      elsif up_p1 = '1' and down_p1 = '1' then
                          player_one_uplimit <= player_one_uplimit;  -- stay at the same place if both
                          player_one_lowlimit <= player_one_lowlimit; -- buttons are pressed.
                         
                      end if;
                 end process;
                 
                 player_two_proc: process(up_p2,down_p2,reset,clk_20hz)
                 begin
                 
                      if reset = '0' then
                          player_two_uplimit <= 320;
                          player_two_lowlimit <= 200;
                      elsif up_p2 = '1' and down_p2 = '0' then
                             if rising_edge(clk_20hz) then                              
                                  if player_two_lowlimit = 1 then
                                      player_two_lowlimit <= player_two_lowlimit;
                                      player_two_uplimit <= player_two_uplimit;
				     else
                                     player_two_uplimit <= player_two_uplimit - 1;
                                     player_two_lowlimit <= player_two_lowlimit - 1;
                                  end if;                                
                             end if;    
                      
                      elsif up_p2 = '0' and down_p2 = '1' then
                              if rising_edge(clk_20hz) then
                                  if player_two_uplimit = 599 then
                                      player_two_lowlimit <= player_two_lowlimit;
                                      player_two_uplimit <= player_two_uplimit;
				     else
                                    player_two_uplimit <= player_two_uplimit + 1;
                                    player_two_lowlimit <= player_two_lowlimit + 1;
                                  end if;                                
                             end if; 
                                           
                      elsif up_p2 = '1' and down_p2 = '1' then
                          player_two_uplimit <= player_two_uplimit;  -- stay at the same place if both
                          player_two_lowlimit <= player_two_lowlimit; -- buttons are pressed.
                         
                      end if;
                 end process;                 

ball_proc:   process(reset,clk_20hz)              
             begin
             if reset = '0' then
                 my_ball_sm <= ball_reset;
             elsif rising_edge(clk_20hz) then     
             case( my_ball_sm) is
             when ball_reset =>      
                                     x_cord <= 470;
                                     y_cord <= 270; 
                                     if delay < 200 then 
                                     delay <= delay + 1;
                                     my_ball_sm <= ball_reset;
                                 else 
                                     delay <= 0;   
                                     my_ball_sm <= left_up;
                                 end if;    
                                 
             when left_up =>     if y_cord < 1 and x_cord > 1 then       -- check if ceil was hit , left movement
                                      my_ball_sm <= left_down;
                                 elsif x_cord = 25 and y_cord > player_one_lowlimit and y_cord <  player_one_uplimit then 
                                        my_ball_sm <= right_up;
                                 elsif x_cord = 1 and y_cord < player_one_lowlimit-1  then
                                        my_ball_sm <= ball_reset;
                                 elsif x_cord = 1 and y_cord > player_one_uplimit+1  then
                                        my_ball_sm <= ball_reset;                                                
                                 else                                
                                 x_cord <= x_cord - 1;                   
                                 y_cord <= y_cord - 1;
                                 end if;
                                 
             when left_down =>   if y_cord > 599 and x_cord > 1 then     -- check if floor was hit , left movement
                                    my_ball_sm <= left_up;
                                  elsif x_cord = 25 and y_cord > player_one_lowlimit and y_cord <  player_one_uplimit then 
                                        my_ball_sm <= right_down;
                                 elsif x_cord = 20 and y_cord < player_one_lowlimit - 1  then
                                        my_ball_sm <= ball_reset;
                                 elsif x_cord = 20 and y_cord > player_one_uplimit + 1  then
                                        my_ball_sm <= ball_reset;                                        
                                  else  
                                  x_cord <= x_cord - 1;                   
                                  y_cord <= y_cord + 1; 
                                  end if; 
                                  
             when right_up => if y_cord < 1 and x_cord < 800 then     -- check if ceil was hit , right movement
                                    my_ball_sm <= right_down;
                                 elsif x_cord = 775 and y_cord > player_two_lowlimit and y_cord <  player_two_uplimit then 
                                        my_ball_sm <= left_up;
                                 elsif x_cord = 785 and y_cord < player_two_lowlimit - 1  then
                                        my_ball_sm <= ball_reset;
                                 elsif x_cord = 785 and y_cord > player_two_uplimit + 1 then
                                        my_ball_sm <= ball_reset;                                        
                                  else  
                                  x_cord <= x_cord + 1;                   
                                  y_cord <= y_cord - 1; 
                                  end if;
                                  
             when right_down => if y_cord > 599 and x_cord < 800  then     -- check if floor was hit , left movement
                                    my_ball_sm <= right_up;
                                  elsif x_cord = 775 and y_cord > player_two_lowlimit and y_cord <  player_two_uplimit then 
                                        my_ball_sm <= left_down;
                                 elsif x_cord = 799 and y_cord < player_two_lowlimit-1  then
                                        my_ball_sm <= ball_reset;
                                 elsif x_cord = 799 and y_cord > player_two_uplimit+1  then
                                        my_ball_sm <= ball_reset;                                        
                                  else  
                                  x_cord <= x_cord + 1;                   
                                  y_cord <= y_cord + 1; 
                                  end if;                                                     
                                                                   
             when others =>      my_ball_sm <= ball_reset;
             end case;
             end if;
             end process;

ball_x_low <= x_cord - 5;
ball_x_high <= x_cord + 5;
ball_y_low <= y_cord - 5;
ball_y_high <= y_cord + 5;



draw_proc : process(H_counter,V_counter,active_region)
            begin
                if active_region = '1' and V_counter > player_one_lowlimit and V_counter < player_one_uplimit and H_counter < H_limit then
                     left_player <= '1';                      
                else
                     left_player <= '0';
                end if;

                if active_region = '1' and V_counter > player_two_lowlimit and V_counter < player_two_uplimit and H_counter > 800 - H_limit then
                    right_player <= '1';
                else
                    right_player <= '0'; 
                end if;   
                
                if active_region = '1'  and  V_counter > ball_y_low and V_counter < ball_y_high and H_counter > ball_x_low and H_counter < ball_x_high then
                       ball <= '1';
                else
                       ball <= '0';
               end if;                          
            end process;
            
screen <= left_player or right_player or ball;

end Behavioral;

------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date: 10/11/2023 10:30:11 PM
---- Design Name: 
---- Module Name: hw2 - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std.all;

--entity hw2 is
--    PORT(
--        clok : in std_logic;
--        rst : in std_logic; --reset
--        hsync : out std_logic;
--        vsync : out std_logic;
--        R,G,B : out std_logic_vector(3 downto 0));
--end hw2;


--architecture Behavioral of hw2 is
--    COMPONENT dist_mem_gen_0
--        PORT (
--            a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--        );
--    END COMPONENT;

--    COMPONENT dist_mem_gen_1
--        PORT(
--            clk : IN STD_LOGIC;
--            we : IN STD_LOGIC;
--            a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--            d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--        );
--    END COMPONENT;

--    signal clk : std_logic := '0';
--    signal address_rom : std_logic_vector(15 DOWNTO 0) := (others => '0');
--    signal data_rom : std_logic_vector(7 DOWNTO 0) := (others => '0');
--    signal address_ram : std_logic_vector(15 DOWNTO 0) := (others => '0');
--    signal address_ram_vga : std_logic_vector(15 downto 0) := (others => '0');
--    signal data_ram_in : std_logic_vector(7 DOWNTO 0) := (others => '0');
--    signal data_ram_out : std_logic_vector(7 DOWNTO 0) := (others => '0');
--    signal wr : std_logic := '1';
--    constant clock_period : time := 10 ps;
--    signal i : integer := 0;
--    signal counter : integer:=0;
--    signal clk50 : std_logic := '0';
--    signal clk25 : std_logic := '0';

--    signal c : std_logic := '0';
--    signal d : std_logic := '0';

--    constant hd : integer := 639;
--    constant hfp : integer := 16; -- horixontal front porch
--    constant hsp : integer := 96; -- horizontal sync porch
--    constant hbp : integer := 48; -- horizontal back porch

--    constant vd : integer := 479;
--    constant vfp : integer := 10;
--    constant vsp : integer := 2;
--    constant vbp : integer := 33;
    
--    signal hpos : integer := 0;
--    signal vpos : integer := 0;

--    signal video_on : std_logic := '0';

--BEGIN

--    -- clock process definitions


--    uut1 : dist_mem_gen_0 PORT map(
--            a => address_rom,
--            spo => data_rom
--        );
--    uut2 : dist_mem_gen_1 PORT MAP (
--            a => address_ram,
--            spo => data_ram_out,
--            clk => clk25,
--            d => data_ram_in,
--            we => wr
--        );
    
--    i_proc : process (i)
--    begin
--        if (i>20000) then
--            wr <= '0';
--        end if;
--    end process;
    
    

--    clock : process
--    begin
--        clk<=not clk;
--        wait for  1 ps;
--    end process;
    
--    clk_div : process(clk)
--    begin
--        if(clk'event and clk = '1') then
--            c <= not c;
--            if (c='0') then
--                clk50<='0';
--            else
--                clk50<='1';
--            end if;
--        -- clk'event - means a change, can be a rising edge or a falling edge
--        -- everytime when the clock changes and is equal to 1
--        -- basically at every rising edge of the clock
--        end if;
--    end process;
    
--    clk_div1 : process(clk50)
--    begin
--        if(clk50'event and clk50 = '1') then
--            d <= not d;
--            if (d='0') then
--                clk25<='0';
--            else
--                clk25<='1';
--            end if;
--        -- clk'event - means a change, can be a rising edge or a falling edge
--        -- everytime when the clock changes and is equal to 1
--        -- basically at every rising edge of the clock
--        end if;
--    end process;

--horizontal_position_counter : process (clk25, rst)
--begin
--    if(rst = '1') then          
--        hpos <= 0;
--    elsif(rising_edge(clk25) and wr = '0') then
--        if(hpos = hd + hfp + hsp + hbp) then
--            hpos <= 0; 
--        else
--            hpos <= hpos + 1;
--        end if;
--    end if;
--end process;

--vertical_position_counter : process (clk25, rst, hpos)
--begin
--    if(rst = '1') then
--        vpos <= 0;
--    elsif(clk25'event and clk25 = '1' and wr = '0') then
--        if(hpos =(hd+hfp+hsp+hbp)) then
--            if(vpos = (vd+vfp+vsp+vbp)) then
--                vpos <= 0;
--            else
--                vpos <= vpos +1;
--            end if;
--        end if;
--    end if;
--end process;

--horizontal_sync : process (clk25, rst, hpos)
--begin
--    if(rst = '1') then
--        hsync <= '0';
--    elsif(clk25'event and clk25 = '1' and wr = '0') then
----        if((hpos <= 655) or (hpos >= 751)) then
--        if((hpos <= (hd+hfp)) or (hpos >= (hd+hfp+hsp))) then
--            hsync <= '1';

--        else
--            hsync <= '0' ;
--        end if;
--    end if;
--end process;


--vertical_sync : process (clk25, rst, vpos)
--begin
--    if(rst = '1') then
--        vsync <= '0';
--    elsif(clk25'event and clk25 = '1' and wr = '0') then
----        if((vpos <= 489) or (vpos > 491)) then
--        if((vpos <= (vd + vfp)) or (vpos > (vd+vfp+vsp))) then
--            vsync <= '1';
--        else
--            vsync <= '0';
--        end if;
--    end if;
--end process;

--video_proc : process (clk25, rst, hpos, vpos)
--begin
--    if(rst = '1') then
--        video_on <= '0';
--    elsif(clk25'event and clk25 = '1' and wr = '0') then
--        if(hpos <= hd and vpos <= vd) then
--            video_on <= '1';
--        else
--            video_on <= '0';
--        end if;
--    end if;
--end process;



--ramadd : process(wr, clk25)
--begin
--    if(wr='0')then
--                address_ram <= std_logic_vector(to_unsigned(256*vpos+hpos, 16));
--    elsif(wr='1' and counter = 2) then
--                address_ram <= std_logic_vector(to_unsigned(i, 16));
--    end if;
--end process;


--draw : process(clk25, rst, hpos, vpos, video_on)
--begin
--    if(rst = '1') then
--        R <= "0000";
--        G <= "0000";
--        B <= "0000";
--    elsif(rising_edge(clk25) and wr = '0') then
--        if(video_on = '1') then
--            if((hpos >= 0 and hpos <= 255) and (vpos >= 0 and vpos <= 255)) then
--                R(3) <= data_ram_out(7);
--                R(2) <= data_ram_out(6);
--                R(1) <= data_ram_out(5);
--                R(0) <= data_ram_out(4);
--                G(3) <= data_ram_out(7);
--                G(2) <= data_ram_out(6);
--                G(1) <= data_ram_out(5);
--                G(0) <= data_ram_out(4);
--                B(3) <= data_ram_out(7);
--                B(2) <= data_ram_out(6);
--                B(1) <= data_ram_out(5);
--                B(0) <= data_ram_out(4);                
--            else
--                R <= "0000";
--                G <= "0000";
--                B <= "0000";
--            end if;
--        else
--            R <= "0000";
--            G <= "0000";
--            B <= "0000";
--        end if;
--    end if;
--end process;

--    d3_proc : process(clk25)
--    variable prev : integer:=0;
--    variable curr : integer:=0;
--    variable nex : integer:=0;
--    variable val : integer;
--    variable out_pix : std_logic_vector(7 downto 0);
    
    
--    begin
--        if (rising_edge(clk25) and i<65536 and wr = '1') then
--            if (counter=0) then
--                if (i mod 256 = 0) then
--                    address_rom <= std_logic_vector(to_unsigned(i, 16));
--                end if;
--                if (i mod 256 /=0) then
--                    prev:=curr;
--                else
--                    prev:=0;
--                end if;
--                counter <= 1;
--            elsif (counter=1) then
--                if (i mod 256 = 0) then
--                    curr := to_integer(unsigned(data_rom));
--                else
--                    curr:=nex;
--                end if;
--                if ((i mod 256)/=255) then
--                    address_rom<=std_logic_vector(to_unsigned(i+1, 16));
--                end if;
--                counter<=2;
--            elsif (counter=2) then
--                if ((i mod 256)/=255) then
--                    nex:=to_integer(unsigned(data_rom));
--                else
--                    nex:=0;
--                end if;
--                val := prev + nex - 2*curr;
--                if (val>255) then
--                    val:=255;
--                elsif (val < 0) then
--                    val:=0;
--                end if;
--                out_pix:= std_logic_vector(to_unsigned(val, 8));
--                --address_ram <= std_logic_vector(to_unsigned(i, 16));
--                data_ram_in<=out_pix;
--                counter<=0;
--                i<=i+1;               
--            end if;                  
--        end if;
--    end process;
    
    
--end Behavioral;




-- lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/11/2023 10:30:11 PM
-- Design Name: 
-- Module Name: hw2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;

entity hw2 is
    PORT(
        clok : in std_logic;
        rst : in std_logic; --reset
        hsync : out std_logic;
        vsync : out std_logic;
       r,g,b : out std_logic_vector(3 downto 0));
end hw2;


architecture Behavioral of hw2 is
    COMPONENT dist_mem_gen_0
        PORT (
            a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT dist_mem_gen_1
        PORT(
            clk : IN STD_LOGIC;
            we : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    
    signal clka : std_logic := '0';

    signal address_rom : std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal data_rom : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal address_ram : std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal address_ram_vga : std_logic_vector(15 downto 0) := (others => '0');
    signal data_ram_in : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal data_ram_out : std_logic_vector(7 DOWNTO 0) := (others => '0');
    signal wr : std_logic := '1';
    constant clock_period : time := 10 ps;
    signal i : integer := 0;
    signal counter : integer:=0;
    signal clk50 : std_logic := '0';
    signal clk25 : std_logic := '0';

    signal c : std_logic := '0';
    signal d_var : std_logic := '0';

    constant hd : integer := 639;
    constant hfp : integer := 16; -- horixontal front porch
    constant hsp : integer := 96; -- horizontal sync porch
    constant hbp : integer := 48; -- horizontal back porch

    constant vd : integer := 479;
    constant vfp : integer := 10;
    constant vsp : integer := 2;
    constant vbp : integer := 33;
    
    signal hpos : integer := 0;
    signal vpos : integer := 0;

    signal video_on : std_logic := '0';

BEGIN

    -- clock process definitions


    uut1 : dist_mem_gen_0 PORT map(
            a => address_rom,
            spo => data_rom
        );
    uut2 : dist_mem_gen_1 PORT MAP (
            a => address_ram,
            spo => data_ram_out,
            clk => clk25,
            d => data_ram_in,
            we => wr
        );
    
    i_proc : process (i)
    begin
        if (i>65536) then
            wr <= '0';
        end if;
    end process;
    
    

    clock : process
    begin
        clka<=not clka;
        wait for  5 ns;
    end process;
    
    clk_div : process(clka)
    begin
        if(clka'event and clka = '1') then
            c <= not c;
            if (c='0') then
                clk50<='0';
            else
                clk50<='1';
            end if;
        -- clk'event - means a change, can be a rising edge or a falling edge
        -- everytime when the clock changes and is equal to 1
        -- basically at every rising edge of the clock
        end if;
    end process;
    
    clk_div1 : process(clk50)
    begin
        if(clk50'event and clk50 = '1') then
            d_var <= not d_var;
            if (d_var='0') then
                clk25<='0';
            else
                clk25<='1';
            end if;
        -- clk'event - means a change, can be a rising edge or a falling edge
        -- everytime when the clock changes and is equal to 1
        -- basically at every rising edge of the clock
        end if;
    end process;

horizontal_position_counter : process (clk25, rst)
begin
    if(rst = '1') then          
        hpos <= 0;
    elsif(rising_edge(clk25) and wr = '0') then
        if(hpos = hd + hfp + hsp + hbp) then
            hpos <= 0; 
        else
            hpos <= hpos + 1;
        end if;
    end if;
end process;

vertical_position_counter : process (clk25, rst, hpos)
begin
    if(rst = '1') then
        vpos <= 0;
    elsif(clk25'event and clk25 = '1' and wr = '0') then
        if(hpos =(hd+hfp+hsp+hbp)) then
            if(vpos = (vd+vfp+vsp+vbp)) then
                vpos <= 0;
            else
                vpos <= vpos +1;
            end if;
        end if;
    end if;
end process;

horizontal_sync : process (clk25, rst, hpos)
begin
    if(rst = '1') then
        hsync <= '0';
    elsif(clk25'event and clk25 = '1' and wr = '0') then
--        if((hpos <= 655) or (hpos >= 751)) then
        if((hpos <= (hd+hfp)) or (hpos >= (hd+hfp+hsp))) then
            hsync <= '1';

        else
            hsync <= '0' ;
        end if;
    end if;
end process;


vertical_sync : process (clk25, rst, vpos)
begin
    if(rst = '1') then
        vsync <= '0';
    elsif(clk25'event and clk25 = '1' and wr = '0') then
--        if((vpos <= 489) or (vpos > 491)) then
        if((vpos <= (vd + vfp)) or (vpos > (vd+vfp+vsp))) then
            vsync <= '1';
        else
            vsync <= '0';
        end if;
    end if;
end process;

video_proc : process (clk25, rst, hpos, vpos)
begin
    if(rst = '1') then
        video_on <= '0';
    elsif(clk25'event and clk25 = '1' and wr = '0') then
        if(hpos <= hd and vpos <= vd) then
            video_on <= '1';
        else
            video_on <= '0';
        end if;
    end if;
end process;



ramadd : process(wr, clk25)
begin
    if(wr='0')then
                address_ram <= std_logic_vector(to_unsigned(256*vpos+hpos, 16));
    elsif(wr='1' and counter = 2) then
                address_ram <= std_logic_vector(to_unsigned(i, 16));
    end if;
end process;


draw : process(clk25, rst, hpos, vpos, video_on)
begin
    if(rst = '1') then
        R <= "0000";
        G <= "0000";
        B <= "0000";
    elsif(rising_edge(clk25) and wr = '0') then
        if(video_on = '1') then
            if((hpos >= 0 and hpos <= 255) and (vpos >= 0 and vpos <= 255)) then
                R(3) <= data_ram_out(7);
                R(2) <= data_ram_out(6);
                R(1) <= data_ram_out(5);
                R(0) <= data_ram_out(4);
                G(3) <= data_ram_out(7);
                G(2) <= data_ram_out(6);
                G(1) <= data_ram_out(5);
                G(0) <= data_ram_out(4);
                B(3) <= data_ram_out(7);
                B(2) <= data_ram_out(6);
                B(1) <= data_ram_out(5);
                B(0) <= data_ram_out(4);                
            else
                R <= "0000";
                G <= "0000";
                B <= "0000";
            end if;
        else
            R <= "0000";
            G <= "0000";
            B <= "0000";
        end if;
    end if;
end process;

    d3_proc : process(clk25)
    variable prev : integer:=0;
    variable curr : integer:=0;
    variable nex : integer:=0;
    variable val : integer;
    variable out_pix : std_logic_vector(7 downto 0);
    
    
    begin
        if (rising_edge(clk25) and i<65536 and wr = '1') then
            if (counter=0) then
                if (i mod 256 = 0) then
                    address_rom <= std_logic_vector(to_unsigned(i, 16));
                end if;
                if (i mod 256 /=0) then
                    prev:=curr;
                else
                    prev:=0;
                end if;
                counter <= 1;
            elsif (counter=1) then
                if (i mod 256 = 0) then
                    curr := to_integer(unsigned(data_rom));
                else
                    curr:=nex;
                end if;
                if ((i mod 256)/=255) then
                    address_rom<=std_logic_vector(to_unsigned(i+1, 16));
                end if;
                counter<=2;
            elsif (counter=2) then
                if ((i mod 256)/=255) then
                    nex:=to_integer(unsigned(data_rom));
                else
                    nex:=0;
                end if;
                val := prev + nex - 2*curr;
                if (val>255) then
                    val:=255;
                elsif (val < 0) then
                    val:=0;
                end if;
                out_pix:= std_logic_vector(to_unsigned(val, 8));
                --address_ram <= std_logic_vector(to_unsigned(i, 16));
                data_ram_in<=out_pix;
                counter<=0;
                i<=i+1;               
            end if;                  
        end if;
    end process;
    
    
end Behavioral;


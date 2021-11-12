library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TbCounter is
end entity TbCounter;

architecture rtl of TbCounter is
    constant CLK_PER : time := 100 ns;
    signal Clk : std_logic;
    signal opt24: std_logic;
    signal enable: std_logic;
    signal init12: std_logic;
    signal BCDup : std_logic_vector (3 downto 0);
    signal BCDdo : std_logic_vector (3 downto 0);
begin
    

    pClk: process
    begin
        Clk <= '1';
        wait for CLK_PER / 2;
        Clk <= '0';
        wait for CLK_PER / 2;
    end process pClk;

  



    test : process
    -- procédure de test
    begin
        -- décalage des données par rapport au front actif d'horloge
        wait for 25 ns;
        -- initialisation à 12, le compteur reste bloqué
        init12 <= '1';
        wait for 500 ns;
        -- enable à 1, toujours bloqué
        enable <= '1';
        wait for 500 ns;
        -- enable à 0, init12 à 0 toujours bloqué
        enable <= '0';
        init12 <= '0';
        wait for 500 ns;
        -- enable à 1, comptage de 1 à 12
        enable  <= '1';
        wait for 3 us;
        -- comptage de 0 à 24
        opt24 <= '1';
        wait for 4.5 us;
        -- comptage de 1 à 12
        opt24 <= '0';
        wait for 3 us;
        -- comptage de 0 à 24
        opt24 <= '1';
        wait for 3 us;
        -- enable à 0, blocage du compteur
        enable <= '0';
        wait for 500 ns;
        -- init12 à 1, initialisation même sans enable 
        init12 <= '1';
        wait for 500 ns;
    end process test;



    counteur_inst : entity work.compteursy
   
    port map (
        clock => Clk,
        opt24 => opt24,
        enable => enable,
        init12 => init12, 
        BCDu => BCDup,
        BCDd => BCDdo
    );



end architecture rtl;



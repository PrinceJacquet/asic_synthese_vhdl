library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------
entity assemblage is

    port (
        clock, opt24,init12,enable : in  std_logic;
        segment_d, segment_u       : out std_logic_vector (6 downto 0)
    );
end assemblage;
---------------------------------------------------------------------
architecture synthetisable of assemblage is

    -- Le compteur

    component compteur
        port (clock, opt24, enable, init12 : in std_logic;
            BCDu : out std_logic_vector (3 downto 0);
            BCDd : out std_logic_vector (3 downto 0));
    end component;


    -- Le décodeur

    component decodeur
        port (BCD : in std_logic_vector (3 downto 0);
            segments : out std_logic_vector (6 downto 0));
    end component;

    -- On ne synthetise pas l'afficheur

    --component afficheur
    --    port (clock : in std_logic;
    --          low   : in std_logic_vector (6 downto 0);
    --          up    : in std_logic_vector (6 downto 0));
    --end component;



    -- Déclarations de signaux


    signal BCDu, BCDd : std_logic_vector (3 downto 0);
    -- 2x4 bits du code BCD 
    --signal seg_u, seg_d : std_logic_vector (6 downto 0);
    -- 7 segments, unités et dizaines

begin
    Compteur_1_to_12_or_0_to_23 :
        compteur port map (clock, opt24, enable, init12, BCDu, BCDd);
    Decodeur_4bits_to_7segments_dizaines :
        decodeur port map (BCDd, segment_d);
    Decodeur_4bits_to_7segments_unites :
        decodeur port map (BCDu, segment_u);



end synthetisable;

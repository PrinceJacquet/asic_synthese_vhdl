library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------
entity montre is
  -- cette entit� n'a pas de signaux :
  -- c'est la proc�dure de test
end montre;
---------------------------------------------------------------------
architecture simulation of montre is

    -- Le compteur

    component compteur
        port (clock, opt24, enable, init12 : in  std_logic;
              BCDu : out std_logic_vector (3 downto 0);
              BCDd : out std_logic_vector (3 downto 0));
    end component;
          
    -- synopsys synthesis_off
    for all: compteur use entity work.compteur(rtl);
    -- synopsys synthesis_on

    -- Le d�codeur

    component decodeur
        port (BCD      : in  std_logic_vector (3 downto 0);
              segments : out std_logic_vector (6 downto 0));
    end component;

    -- synopsys synthesis_off
    for all: decodeur use entity work.decodeur(rtl);

    -- L'afficheur

    component afficheur
        port (clock : in std_logic;
              low   : in std_logic_vector (6 downto 0);
              up    : in std_logic_vector (6 downto 0));
    end component;

    for all: afficheur use entity work.afficheur;
    -- synopsys synthesis_on

    -- D�clarations de signaux

    signal clock    : std_logic := '1'; -- l'horloge
    signal opt24    : std_logic := '0'; -- le mode de comptage
    signal enable   : std_logic := '0'; -- l'autorisation de comptage
    signal init12   : std_logic := '0'; -- l'initialisation � 12
    signal BCDu,  BCDd  : std_logic_vector (3 downto 0); 
                                        -- 2x4 bits du code BCD 
    signal seg_u, seg_d : std_logic_vector (6 downto 0); 
                                        -- 7 segments, unit�s et dizaines

begin
    Compteur_1_to_12_or_0_to_23 : 
    compteur  port map (clock, opt24, enable, init12, BCDu, BCDd);
    Decodeur_4bits_to_7segments_dizaines :
    decodeur  port map (BCDu, seg_d);
    Decodeur_4bits_to_7segments_unites :
    decodeur  port map (BCDd, seg_u);

    -- synopsys synthesis_off

    Afficheur_7segments_to_ecran :
    afficheur port map (clock, seg_d, seg_u);
	
    -- g�n�ration de l'horloge
	clock <= not clock after 50 ns;

    test : process
    -- proc�dure de test
    begin
        -- d�calage des donn�es par rapport au front actif d'horloge
        wait for 25 ns;
        -- initialisation � 12, le compteur reste bloqu�
        init12 <= '1';
        wait for 500 ns;
        -- enable � 1, toujours bloqu�
        enable <= '1';
        wait for 500 ns;
        -- enable � 0, init12 � 0 toujours bloqu�
        enable <= '0';
        init12 <= '0';
        wait for 500 ns;
        -- enable � 1, comptage de 1 � 12
        enable  <= '1';
        wait for 3 us;
        -- comptage de 0 � 24
        opt24 <= '1';
        wait for 4.5 us;
        -- comptage de 1 � 12
        opt24 <= '0';
        wait for 3 us;
        -- comptage de 0 � 24
        opt24 <= '1';
        wait for 3 us;
        -- enable � 0, blocage du compteur
        enable <= '0';
        wait for 500 ns;
        -- init12 � 1, initialisation m�me sans enable 
        init12 <= '1';
        wait for 500 ns;
    end process test;

    arret : process
    -- arr�t de la simulation
    begin
        assert NOW < 16 us report "Fin de simulation" severity ERROR;
        wait on clock;
    end process arret;

    -- synopsys synthesis_on

end simulation;
-- synopsys synthesis_on

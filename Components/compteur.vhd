--Mouloud ZIANE 
--Prince Jacquet
--M2 SME
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity compteur is
    port(
        clock, opt24,init12,enable : in  std_logic;
        BCDu, BCDd                 : out std_logic_vector (3 downto 0)
    );
end entity compteur;

architecture synthetisable of compteur is

    signal countingReg  : std_logic_vector (4 downto 0); --24 max == 0b11000
    signal countingShow : std_logic_vector (4 downto 0); --24 max == 0b11000
                                                         --signal countingReg  : integer range 0 to 24; --24 max == 0b11000
                                                         --signal countingShow : integer range 0 to 24; --24 max == 0b11000
    signal opt24_s : std_logic;
    signal unit    : std_logic_vector (4 downto 0);

begin

    pcompteursy : process(clock, init12)
        -- l'horloge a besoin : un increment sur enable + une RaZ à 24hr + une Init sur init12 synchrone

    begin

        if (clock'event and clock = '1') then

            opt24_s <= opt24;

            if (enable = '1') then
                countingReg <= countingReg + '1';
            end if;

            if (countingReg = 23) and (enable = '1') then --at 23 on reset le compteur
                countingReg <= (others => '0');
            end if;

            if init12 = '1' then
                countingReg <= "01100"; --recoit 12
            end if;

        end if;

    end process pcompteursy;




    countingShow <= (countingReg - 12 )when ( ( countingReg >= 13) and (opt24_s = '0')) else 
					"01100" when ((countingReg = 0) and (opt24_s = '0'))else 
					countingReg ;

    unit <= countingShow - 10 when countingShow >= 10 and countingShow < 20 else
        countingShow - 20 when countingShow >= 20 else
        countingShow ; --when countingShow < 10;

    BCDu <= unit( 3 downto 0);
    BCDd <= "0000" when countingShow < 10 else
        "0001" when countingShow >= 10 and countingShow < 20 else
        "0010" when countingShow >= 20 ;

end architecture synthetisable;


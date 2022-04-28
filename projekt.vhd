-----------------------------------------------------------------------------------------------------
--Wykorzystane biblioteki
-----------------------------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity projekt is

-----------------------------------------------------------------------------------------------------
--deklaracja portów
-----------------------------------------------------------------------------------------------------
port( CLOCK_100MHz : in std_logic; -- zegar 100 MHz 
 RGB : in std_logic_vector(2 downto 0); 
 RED : out std_logic; 
 GRN : out std_logic; 
 BLU : out std_logic; 
 dioda : out std_logic;
 BTN_L : in  std_logic;
 BTN_R : in  std_logic;
 RESET : in std_logic ;
 H_SYNC, V_SYNC : inout std_logic ); 
end;
 
architecture beh of projekt is 
-----------------------------------------------------------------------------------------------------
--Sygnały obsługi sterownika VGA 
-----------------------------------------------------------------------------------------------------

	signal video_on : std_logic; 
	signal h_count : unsigned(9 downto 0); -- licznik kolumn 
	signal v_count : unsigned(9 downto 0); -- licznik wierszy 
	signal pixel_column : unsigned(9 downto 0); -- sygnal pomocniczy 
	signal pixel_row : unsigned(9 downto 0); -- sygnal pomocniczy 
-----------------------------------------------------------------------------------------------------
	signal GAME_ON : std_logic := '1';


-----------------------------------------------------------------------------------------------------
--Sygnał zegar 25 Mhz 
-----------------------------------------------------------------------------------------------------
	signal clock_25MHz : std_logic; -- zegar 25 MHz
	COMPONENT PLLmagisterska IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
END COMPONENT;
-----------------------------------------------------------------------------------------------------	


-----------------------------------------------------------------------------------------------------
--Zmienne oraz sygnały wymagane do wyświetlenia oraz obsługi 39 kul wprowadzonych do gry
-----------------------------------------------------------------------------------------------------

--Tablica 8 elementowa, gdzie każdy element zawiera wektor 8 bitowy, służąca wyświetlaniu kul na ekranie 
-----------------------------------------------------------------------------------------------------
type BALL_ROM is array (7 downto 0) of
 std_logic_vector(7 downto 0); 
constant SMALL_BALL: BALL_ROM := 
(
"00111100", 
"01111110",  
"11111111", 
"11111111", 
"11111111", 
"11111111",  
"01111110",
"00111100" 
); 

--Parametry służące układowi w określeniu wyświetlanych pikseli i ich wartości w stosunku do kulek
-- 28 sygnałów rom_col_ball
-- 18 sygnałów rom_addr_ball
-- 39 sygnałów rom_data_ball
-- 39 sygnałów rom_bit_ball 
-----------------------------------------------------------------------------------------------------
signal rom_addr_ball_1 , rom_col_ball_1 : unsigned (2 downto 0) ; 
signal rom_data_ball_1: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_1 : std_logic ; 

signal rom_addr_ball_2 , rom_col_ball_2 : unsigned (2 downto 0) ; 
signal rom_data_ball_2: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_2 : std_logic := '0' ; 

signal rom_addr_ball_3 , rom_col_ball_3 : unsigned (2 downto 0) ; 
signal rom_data_ball_3: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_3 : std_logic  :='0' ; 

signal rom_addr_ball_4 , rom_col_ball_4 : unsigned (2 downto 0) ; 
signal rom_data_ball_4: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_4 : std_logic :='0'  ; 

signal rom_addr_ball_5 , rom_col_ball_5 : unsigned (2 downto 0) ; 
signal rom_data_ball_5: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_5 : std_logic :='0'  ; 

signal rom_addr_ball_6 , rom_col_ball_6 : unsigned (2 downto 0) ; 
signal rom_data_ball_6: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_6 : std_logic :='0'  ; 

signal rom_addr_ball_7 , rom_col_ball_7 : unsigned (2 downto 0) ; 
signal rom_data_ball_7: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_7 : std_logic :='0'  ; 

signal rom_addr_ball_8 , rom_col_ball_8 : unsigned (2 downto 0) ; 
signal rom_data_ball_8: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_8 : std_logic :='0'  ; 

signal rom_addr_ball_9 , rom_col_ball_9 : unsigned (2 downto 0) ; 
signal rom_data_ball_9: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_9 : std_logic :='0'  ; 

signal rom_addr_ball_10 , rom_col_ball_10 : unsigned (2 downto 0) ; 
signal rom_data_ball_10: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_10 : std_logic :='0'  ; 

signal rom_addr_ball_11 , rom_col_ball_11 : unsigned (2 downto 0) ; 
signal rom_data_ball_11: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_11 : std_logic :='0'  ; 

signal rom_addr_ball_12 , rom_col_ball_12 : unsigned (2 downto 0) ; 
signal rom_data_ball_12: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_12 : std_logic :='0'  ; 

signal rom_addr_ball_13 , rom_col_ball_13 : unsigned (2 downto 0) ; 
signal rom_data_ball_13: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_13 : std_logic :='0'  ; 

signal rom_addr_ball_14 , rom_col_ball_14 : unsigned (2 downto 0) ; 
signal rom_data_ball_14: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_14 : std_logic :='0'  ; 

signal rom_addr_ball_15 , rom_col_ball_15 : unsigned (2 downto 0) ; 
signal rom_data_ball_15: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_15 : std_logic :='0'  ; 

signal rom_addr_ball_16 , rom_col_ball_16 : unsigned (2 downto 0) ; 
signal rom_data_ball_16: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_16 : std_logic :='0'  ; 

signal rom_addr_ball_17 , rom_col_ball_17 : unsigned (2 downto 0) ; 
signal rom_data_ball_17: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_17 : std_logic :='0'  ; 

signal rom_addr_ball_18 , rom_col_ball_18 : unsigned (2 downto 0) ; 
signal rom_data_ball_18: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_18 : std_logic :='0'  ; 

signal  rom_col_ball_19 : unsigned (2 downto 0) ; 
signal rom_data_ball_19: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_19 : std_logic :='0'  ; 

signal  rom_col_ball_20 : unsigned (2 downto 0) ; 
signal rom_data_ball_20: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_20 : std_logic :='0'  ; 

signal  rom_col_ball_21 : unsigned (2 downto 0) ; 
signal rom_data_ball_21: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_21 : std_logic :='0'  ;

signal  rom_col_ball_22 : unsigned (2 downto 0) ; 
signal rom_data_ball_22: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_22 : std_logic :='0'  ;

signal  rom_col_ball_23 : unsigned (2 downto 0) ; 
signal rom_data_ball_23: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_23 : std_logic :='0'  ;

signal  rom_col_ball_24 : unsigned (2 downto 0) ; 
signal rom_data_ball_24: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_24 : std_logic :='0'  ;

signal  rom_col_ball_25 : unsigned (2 downto 0) ; 
signal rom_data_ball_25: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_25 : std_logic :='0'  ;

signal  rom_col_ball_26 : unsigned (2 downto 0) ; 
signal rom_data_ball_26: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_26 : std_logic :='0'  ;

signal  rom_col_ball_27 : unsigned (2 downto 0) ; 
signal rom_data_ball_27: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_27 : std_logic :='0'  ;

signal  rom_col_ball_28 : unsigned (2 downto 0) ; 
signal rom_data_ball_28: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_28 : std_logic :='0'  ;

signal rom_data_ball_29: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_29 : std_logic :='0'  ;

signal rom_data_ball_30: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_30 : std_logic :='0'  ;

signal rom_data_ball_31: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_31 : std_logic :='0'  ;

signal rom_data_ball_32: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_32 : std_logic :='0'  ;

signal rom_data_ball_33: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_33 : std_logic :='0'  ;

signal rom_data_ball_34: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_34 : std_logic :='0'  ;

signal rom_data_ball_35: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_35 : std_logic :='0'  ;

signal rom_data_ball_36: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_36 : std_logic :='0'  ;

signal rom_data_ball_37: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_37 : std_logic :='0'  ;

signal rom_data_ball_38: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_38 : std_logic :='0'  ;

signal rom_data_ball_39: std_logic_vector (7 downto 0) ; 
signal rom_bit_ball_39 : std_logic :='0'  ;

--Sygnały służące układowi w określeniu czy dana kula ma się wyświetlić
signal sq_S_BALL_on_1: std_logic;
signal sq_S_BALL_on_2: std_logic;	
signal sq_S_BALL_on_3: std_logic;	
signal sq_S_BALL_on_4: std_logic;	
signal sq_S_BALL_on_5: std_logic;
signal sq_S_BALL_on_6: std_logic;	
signal sq_S_BALL_on_7: std_logic;	
signal sq_S_BALL_on_8: std_logic;	
signal sq_S_BALL_on_9: std_logic;	
signal sq_S_BALL_on_10: std_logic;	
signal sq_S_BALL_on_11: std_logic;	
signal sq_S_BALL_on_12: std_logic;	
signal sq_S_BALL_on_13: std_logic;	
signal sq_S_BALL_on_14: std_logic;	
signal sq_S_BALL_on_15: std_logic;	
signal sq_S_BALL_on_16: std_logic;	
signal sq_S_BALL_on_17: std_logic;	
signal sq_S_BALL_on_18: std_logic;	
signal sq_S_BALL_on_19: std_logic;	
signal sq_S_BALL_on_20: std_logic;	
signal sq_S_BALL_on_21: std_logic;
signal sq_S_BALL_on_22: std_logic;
signal sq_S_BALL_on_23: std_logic;
signal sq_S_BALL_on_24: std_logic;
signal sq_S_BALL_on_25: std_logic;
signal sq_S_BALL_on_26: std_logic;
signal sq_S_BALL_on_27: std_logic;
signal sq_S_BALL_on_28: std_logic;
signal sq_S_BALL_on_29: std_logic;
signal sq_S_BALL_on_30: std_logic;
signal sq_S_BALL_on_31: std_logic;
signal sq_S_BALL_on_32: std_logic;
signal sq_S_BALL_on_33: std_logic;
signal sq_S_BALL_on_34: std_logic;
signal sq_S_BALL_on_35: std_logic;
signal sq_S_BALL_on_36: std_logic;
signal sq_S_BALL_on_37: std_logic;
signal sq_S_BALL_on_38: std_logic;
signal sq_S_BALL_on_39: std_logic;

--Sygnał końcowy obsługi wyświetlania kuli, wskazujący czy piksel ma się zaświecić.		
signal rd_S_BALL_on_1 : std_logic; 


--Sygnały wykorzystywane do określenia stanu danej kuli (wartość 1 - wyświetl kulę, wartość 0 - ukryj kulę
signal S_BALL_1 : std_logic := '1';
signal S_BALL_2 : std_logic := '1';
signal S_BALL_3 : std_logic := '1';
signal S_BALL_4 : std_logic := '1';
signal S_BALL_5 : std_logic := '1';
signal S_BALL_6 : std_logic := '1';
signal S_BALL_7 : std_logic := '1';
signal S_BALL_8 : std_logic := '1';
signal S_BALL_9 : std_logic := '1';
signal S_BALL_10 : std_logic := '1';
signal S_BALL_11 : std_logic := '1';
signal S_BALL_12 : std_logic := '1';
signal S_BALL_13 : std_logic := '1';
signal S_BALL_14 : std_logic := '1';
signal S_BALL_15 : std_logic := '1';
signal S_BALL_16 : std_logic := '1';
signal S_BALL_17 : std_logic := '1';
signal S_BALL_18 : std_logic := '1';
signal S_BALL_19 : std_logic := '1';
signal S_BALL_20 : std_logic := '1';
signal S_BALL_21 : std_logic := '1';
signal S_BALL_22 : std_logic := '1';
signal S_BALL_23 : std_logic := '1';
signal S_BALL_24 : std_logic := '1';
signal S_BALL_25 : std_logic := '1';
signal S_BALL_26 : std_logic := '1';
signal S_BALL_27 : std_logic := '1';
signal S_BALL_28 : std_logic := '1';
signal S_BALL_29 : std_logic := '1';
signal S_BALL_30 : std_logic := '1';
signal S_BALL_31 : std_logic := '1';
signal S_BALL_32 : std_logic := '1';
signal S_BALL_33 : std_logic := '1';
signal S_BALL_34 : std_logic := '1';
signal S_BALL_35 : std_logic := '1';
signal S_BALL_36 : std_logic := '1';
signal S_BALL_37 : std_logic := '1';
signal S_BALL_38 : std_logic := '1';
signal S_BALL_39 : std_logic := '1';

----------------------------------------------------------------------------------------------------------------------------------
--Sygnały pozycję kul w przestrzeni dwuwymiarowej X Y 
----------------------------------------------------------------------------------------------------------------------------------

--Wartość X (współrzędne) dla kul znajdujących się 
--po lewej oraz prawej stronie labiryntu.
signal X_S_BALL_LEFT : integer := 69;
signal X_S_BALL_RIGHT : integer := 564;

--Wartość X (współrzędne) dla kul znajdujących się 
--w dwóch przejściach pionowych.
signal X_S_BALL_MIDDLELEFT: integer := 255;
signal X_S_BALL_MIDDLERIGHT: integer := 355; 

--Wartości Y (współrzędne) dla kul znajdujących się 
--po lewej, lewy pionowy tunel, prawy pionowy tunel, 
--po prawej stronie labiryntu.
signal Y_S_BALL_LEFTRIGHT_1 : integer := 100;
signal Y_S_BALL_LEFTRIGHT_2 : integer := 150;
signal Y_S_BALL_LEFTRIGHT_3 : integer := 200;
signal Y_S_BALL_LEFTRIGHT_4 : integer := 300;
signal Y_S_BALL_LEFTRIGHT_5 : integer := 350;

--Wartości Y (współrzędne) dla kul znajdujących się 
--na górze, w poziomym tunelu oraz dla dolnej części labiryntu. 
signal Y_S_BALL_UP: integer := 69;
signal Y_S_BALL_MIDDLE: integer := 255;
signal Y_S_BALL_DOWN: integer := 388;

--Wartość X (współrzędne) dla kul znajdujących się 
--na górze, w poziomym tunelu oraz dla dolnej części labiryntu.
signal X_S_BALL_UPMIDDLEDOWN_1 : integer := 120;
signal X_S_BALL_UPMIDDLEDOWN_2 : integer := 170;
signal X_S_BALL_UPMIDDLEDOWN_3 : integer := 220;
signal X_S_BALL_UPMIDDLEDOWN_4 : integer := 280;
signal X_S_BALL_UPMIDDLEDOWN_5 : integer := 390;
signal X_S_BALL_UPMIDDLEDOWN_6 : integer := 440;
signal X_S_BALL_UPMIDDLEDOWN_7 : integer := 490;
signal X_S_BALL_UPMIDDLEDOWN_8 : integer := 540;

--Tablica 8-elementowa w celu wyświetlenia dużej kuli
-----------------------------------------------------------------------------------

type rom_BIG_BALL is array(15 downto 0 ) of
 std_logic_vector(15 downto 0 );
constant BIG_BALL: rom_BIG_BALL :=
(
 "0000000000000000",
 "0000001111000000",
 "0000111111110000",
 "0001111111111000",
 "0011111111111100",
 "0011111111111100",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0011111111111100",
 "0011111111111100",
 "0001111111111000",
 "0000011111100000",
 "0000000000000000"
);	



signal X_B_BALL : integer := 310;
signal Y_B_BALL : integer := 251;

signal rom_addr_B_BALL : unsigned (3 downto 0) ;
signal rom_col_B_BALL  : unsigned (3 downto 0) ;
signal rom_data_B_BALL : std_logic_vector (15 downto 0) ; 
signal rom_bit_B_BALL  : std_logic;
signal sq_B_BALL_on    : std_logic := '1';
signal rd_B_BALL_on    : std_logic := '1';
signal B_BALL          : std_logic := '1';
signal COUNTER_BIG_BALL: natural := 0;
signal ATTACK : std_logic := '0';
signal ATTACK_ACTIVATION : std_logic := '0';
-----------------------------------------------------------------------------------
--Zmienne oraz sygnały wymagane do wyświetlenia oraz obsługi postaci Pac-mana w grze
-----------------------------------------------------------------------------------

--16-nasto elementowa tablica, gdzie każdy element jest jest 16-bitowym ciągiem.  
-----------------------------------------------------------------------------------	

--Zdefiniowany wygląd Pac-mana idącego w lewą stronę
type rom_PACMAN_LEFT is array(15 downto 0 ) of
 std_logic_vector(15 downto 0 );
constant PACMAN_LEFT: rom_PACMAN_LEFT :=
(
 "0000000000000000",
 "0000011111000000",
 "0000111111110000",
 "0001111111111000",
 "0011111111111100",
 "0011111111111110",
 "0111111111111000",
 "0111111111100000",
 "0111111111000000",
 "0111111111100000",
 "0111111111111000",
 "0011111111111110",
 "0011111111111100",
 "0000111111111000",
 "0000011111100000",
 "0000000000000000"
);	

-- "0000001111100000",
-- "0000111111110000",
-- "0001111111111000",
-- "0011111111111100",
-- "0111111111111110",
-- "1111111111111111",
-- "1111111111111100",
-- "1111111111110000",
-- "1111111111100000",
-- "1111111111110000",
-- "1111111111111100",
-- "0111111111111111",
-- "0011111111111110",
-- "0001111111111100",
-- "0000111111111000",
-- "0000001111100000"

--Zdefiniowany wygląd Pac-mana idącego w prawą stronę
type rom_PACMAN_RIGHT is array(15 downto 0 ) of
 std_logic_vector(15 downto 0 );
constant PACMAN_RIGHT: rom_PACMAN_RIGHT :=
(
"0000000000000000",
"0000001111000000",
"0000111111110000",
"0001111111111000",
"0011111111111100",
"0111111111111100",
"0001111111111110",
"0000011111111110",
"0000001111111110",
"0000011111111110",
"0001111111111100",
"0111111111111100",
"0011111111111000",
"0001111111110000",
"0000011111000000",
"0000000000000000"
);	

--Zdefiniowany wygląd Pac-mana idącego w górę 
type rom_PACMAN_UP is array(15 downto 0 ) of
 std_logic_vector(15 downto 0 );
constant PACMAN_UP: rom_PACMAN_UP :=
(
 "0000000000000000",
 "0000001111000000",
 "0000111111110000",
 "0001111111111000",
 "0011111111111100",
 "0011111111111100",
 "0011111111111100",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111011111110",
 "0011110001111100",
 "0011110000111100",
 "0001100000111000",
 "0000100000010000",
 "0000000000000000"
);	

--Zdefiniowany wygląd Pac-mana idącego w dół
type rom_PACMAN_DOWN is array(15 downto 0 ) of
 std_logic_vector(15 downto 0 );
constant PACMAN_DOWN: rom_PACMAN_DOWN :=
(
 "0000000000000000",
 "0000100000100000",
 "0001100000110000",
 "0011110000111000",
 "0011110001111100",
 "0111111011111100",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111100",
 "0011111111111100",
 "0011111111111000",
 "0001111111110000",
 "0000011111000000",
 "0000000000000000"
);	

--Zdefiniowany wygląd Pac-mana z zamkniętą buzią
type rom_PACMAN_FULL is array(0 to 15) of
 std_logic_vector(15 downto 0 );
constant PACMAN_FULL: rom_PACMAN_FULL :=
(
 "0000000000000000",
 "0000001111000000",
 "0000111111110000",
 "0001111111111000",
 "0011111111111100",
 "0011111111111100",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0011111111111100",
 "0011111111111100",
 "0001111111111000",
 "0000111111110000",
 "0000001111000000",
 "0000000000000000"
);	

--Parametry służące układowi w określeniu wyświetlanych pikseli 
--i ich wartości w stosunku postaci Pac-mana.
-----------------------------------------------------------------------------------	
signal rom_addr_pacman , rom_col_pacman : unsigned (3 downto 0) ; 
signal rom_data_pacman: std_logic_vector (15 downto 0) ; 
signal rom_bit_pacman : std_logic ; 
signal rd_PACMAN_on : std_logic; 
signal sq_PACMAN_on: std_logic;									
signal X_PACMAN : integer :=100;
signal Y_PACMAN : integer :=65;
signal PACMAN_COUNTER : natural range 0 to 5000000 :=0;
signal PACMAN_COUNTER_MOUTH : natural range 0 to 5000000;
signal PACMAN_CHOICE  : std_logic := '0';
signal PACMAN_K : std_logic_vector(2 downto 0);
signal PACMAN_WAY : natural range 0 to 3 :=0;

-----------------------------------------------------------------------------------
--Zmienne oraz sygnały wymagane do wyświetlenia oraz obsługi postaci ducha w grze
-----------------------------------------------------------------------------------

--16-nasto elementowa tablica, gdzie każdy element jest jest 16-bitowym ciągiem.  
-----------------------------------------------------------------------------------	

type rom_GHOST is array(0 to 15) of
 std_logic_vector(15 downto 0);
constant GHOST: rom_GHOST :=
(
 "0001111111111000",
 "0011111111111100",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111110111101110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0111111111111110",
 "0110111001110110",
 "0100010000100010"
);

--Parametry służące układowi w określeniu wyświetlanych
--pikseli i ich wartości w stosunku postaci ducha.
-----------------------------------------------------------------------------------	
signal rom_addr_ghost , rom_col_ghost : unsigned (3 downto 0) ; 
signal rom_data_ghost: std_logic_vector (15 downto 0) ; 
signal rom_bit_ghost : std_logic ; 
signal rd_GHOST_on : std_logic; 
signal sq_GHOST_on: std_logic;	
signal X_GHOST : integer :=560;
signal Y_GHOST : integer :=384;

--Parametry ścian
--------------------------------------------------------------------------
signal wall_on :std_logic;

--Lewa ściana
constant WALL_LEFT_X1: integer := 0;
constant WALL_LEFT_X2: integer := 63;

--Górna ściana
--constant WALL_UP_Y1 : integer := 0;
constant WALL_UP_Y1 : integer := 40;
constant WALL_UP_Y2 : integer := 64;

--Dolna ściana
constant WALL_DOWN_Y1 : integer := 401;
--constant WALL_DOWN_Y2 : integer := 480;
constant WALL_DOWN_Y2 : integer := 440;

--Prawa ściana
constant WALL_RIGHT_X1 : integer := 576;
constant WALL_RIGHT_X2 : integer := 640;

--Lewy górny prostokąt
constant WALL_LEFTUP_X1: integer := 80; 
constant WALL_LEFTUP_X2 : integer := 250; 
constant WALL_LEFTUP_Y1 : integer := 81;
constant WALL_LEFTUP_Y2 : integer := 250;

--Prawy górny prostokąt 
constant WALL_RIGHTUP_X1: integer := 267 ;
constant WALL_RIGHTUP_X2: integer := 559 ;
constant WALL_RIGHTUP_Y1: integer := 81 ;
constant WALL_RIGHTUP_Y2: integer := 250 ;

--Lewy dolny prostokąt
constant WALL_LEFTDOWN_X1: integer := 80 ; 
constant WALL_LEFTDOWN_X2: integer := 350 ;
constant WALL_LEFTDOWN_Y1: integer := 267 ;
constant WALL_LEFTDOWN_Y2: integer := 384; 

--Prawy dolny prostokąt
constant WALL_RIGHTDOWN_X1: integer := 367 ;
constant WALL_RIGHTDOWN_X2: integer := 559 ;
constant WALL_RIGHTDOWN_Y1: integer := 267 ;
constant WALL_RIGHTDOWN_Y2: integer := 384 ; 
--------------------------------------------------------------------------

type rom_P is array(0 to 31) of
 std_logic_vector(0 to 31);
constant P: rom_P :=

(
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111000000000000111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111",
 "00000000000000000111111111111111"
);


signal LETTER_POSITION_Y : integer := 2;
signal LETTER_POSITION_P_X : integer :=100;
signal rom_addr_P , rom_col_P : unsigned (4 downto 0) ; 
signal rom_data_P: std_logic_vector (31 downto 0) ; 
signal rom_bit_P : std_logic ; 
signal rd_P_on : std_logic; 
signal sq_P_on: std_logic;	

--------------------------------------------------------------------------

type rom_A is array(0 to 31) of
 std_logic_vector(0 to 31);
constant A: rom_A :=

(
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111",
 "11111111110000000000001111111111"
);



signal LETTER_POSITION_A_X : integer :=140;
signal LETTER_POSITION_A_X2 : integer :=292;
signal rom_addr_A , rom_col_A : unsigned (4 downto 0) ; 
signal rom_data_A: std_logic_vector (31 downto 0) ; 
signal rom_bit_A : std_logic ; 
signal rd_A_on : std_logic; 
signal sq_A_on: std_logic;	

signal rom_addr_A2 , rom_col_A2 : unsigned (4 downto 0) ; 
signal rom_data_A2: std_logic_vector (31 downto 0) ; 
signal rom_bit_A2 : std_logic ; 
signal rd_A2_on : std_logic; 
signal sq_A2_on: std_logic;	

--------------------------------------------------------------------------


--------------------------------------------------------------------------

type rom_C is array(0 to 31) of
 std_logic_vector(0 to 31);
constant C: rom_C :=

(
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "00000000000000000000011111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111"
);



signal LETTER_POSITION_C_X : integer :=178;
signal rom_addr_C , rom_col_C : unsigned (4 downto 0) ; 
signal rom_data_C: std_logic_vector (31 downto 0) ; 
signal rom_bit_C : std_logic ; 
signal rd_C_on : std_logic; 
signal sq_C_on: std_logic;	

--------------------------------------------------------------------------

type rom_POD is array(0 to 31) of
 std_logic_vector(0 to 31);
constant POD: rom_POD :=

(
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "11111111111111111111111111111111",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000",
 "00000000000000000000000000000000"
);



signal LETTER_POSITION_POD_X : integer :=216;
signal rom_addr_POD , rom_col_POD : unsigned (4 downto 0) ; 
signal rom_data_POD: std_logic_vector (31 downto 0) ; 
signal rom_bit_POD : std_logic ; 
signal rd_POD_on : std_logic; 
signal sq_POD_on: std_logic;	


--------------------------------------------------------------------------

type rom_M is array(0 to 31) of
 std_logic_vector(0 to 31);
constant M: rom_M :=

(
 "11111111000000000000000001111111",
 "11111111100000000000000011111111",
 "11111111110000000000000111111111",
 "11111111111000000000001111111111",
 "11111111111100000000011111111111",
 "11111111111110000000111111111111",
 "11111111111111000001111111111111",
 "11111111011111100011111111111111",
 "11111111001111110111111011111111",
 "11111111000111111111110011111111",
 "11111111000011111111100011111111",
 "11111111000001111111000011111111",
 "11111111000000111110000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111"
);



signal LETTER_POSITION_M_X : integer :=254;

signal rom_addr_M , rom_col_M : unsigned (4 downto 0) ; 
signal rom_data_M: std_logic_vector (31 downto 0) ; 
signal rom_bit_M : std_logic ; 
signal rd_M_on : std_logic; 
signal sq_M_on: std_logic;	

--------------------------------------------------------------------------
type rom_N is array(0 to 31) of
 std_logic_vector(0 to 31);
constant N: rom_N :=

(
 "11111111000000000000000011111111",
 "11111111000000000000000111111111",
 "11111111000000000000001111111111",
 "11111111000000000000011111111111",
 "11111111000000000000111111111111",
 "11111111000000000001111111111111",
 "11111111000000000011111111111111",
 "11111111000000000111111011111111",
 "11111111000000001111110011111111",
 "11111111000000011111100011111111",
 "11111111000000111111000011111111",
 "11111111000001111110000011111111",
 "11111111000011111100000011111111",
 "11111111000111111000000011111111",
 "11111111001111110000000011111111",
 "11111111011111100000000011111111",
 "11111111111111000000000011111111",
 "11111111111110000000000011111111",
 "11111111111100000000000011111111",
 "11111111111000000000000011111111",
 "11111111110000000000000011111111",
 "11111111100000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111",
 "11111111000000000000000011111111"
);


signal LETTER_POSITION_N_X : integer :=330;
signal rom_addr_N , rom_col_N : unsigned (4 downto 0) ; 
signal rom_data_N: std_logic_vector (31 downto 0) ; 
signal rom_bit_N : std_logic ; 
signal rd_N_on : std_logic; 
signal sq_N_on: std_logic;	
signal COUNTER : integer := 0;

--------------------------------------------------------------------------

--Zdefiniowany wygląd Pac-mana z zamkniętą buzią
type rom_HEART is array(0 to 15) of
 std_logic_vector(15 downto 0 );
constant HEART: rom_HEART :=
(
 "0001100000110000",
 "0011110001111000",
 "0111111011111100",
 "1111111111111110",
 "1111111111111110",
 "1111111111111110",
 "1111111111111110",
 "1111111111111110",
 "0111111111111100",
 "0111111111111100",
 "0011111111111000",
 "0001111111110000",
 "0000111111100000",
 "0000011111000000",
 "0000001110000000",
 "0000000100000000"
);	

signal HEART_1 : std_logic := '1';
signal HEART_2 : std_logic := '1';
signal HEART_3 : std_logic := '1';

signal LETTER_POSITION_HEART_Y : integer := 450;

signal LETTER_POSITION_HEART_1_X : integer :=516;
signal rom_addr_HEART_1 , rom_col_HEART_1 : unsigned (3 downto 0) ; 
signal rom_data_HEART_1: std_logic_vector (15 downto 0) ; 
signal rom_bit_HEART_1 : std_logic ; 
signal rd_HEART_1_on : std_logic; 
signal sq_HEART_1_on: std_logic;	

signal LETTER_POSITION_HEART_2_X : integer :=536;
signal rom_addr_HEART_2 , rom_col_HEART_2 : unsigned (3 downto 0) ; 
signal rom_data_HEART_2: std_logic_vector (15 downto 0) ; 
signal rom_bit_HEART_2 : std_logic ; 
signal rd_HEART_2_on : std_logic; 
signal sq_HEART_2_on: std_logic;	

signal LETTER_POSITION_HEART_3_X : integer :=556;
signal rom_addr_HEART_3 , rom_col_HEART_3 : unsigned (3 downto 0) ; 
signal rom_data_HEART_3: std_logic_vector (15 downto 0) ; 
signal rom_bit_HEART_3 : std_logic ; 
signal rd_HEART_3_on : std_logic; 
signal sq_HEART_3_on: std_logic;	

signal HEART_LOSS : std_logic := '0';

-----------------------------------------------------------------------------------	
--Napis YOU WIN
-----------------------------------------------------------------------------------
type rom_WIN is array(0 to 15) of
 std_logic_vector(75 downto 0);
constant WIN: rom_WIN :=
(
"1110000001110011100111000000111000011100001110011111111111100111000000000111",
"1110000011110011100111000000111000011100001110011111111111100011100000001110",
"1110000111110011100111000000111000011100001110011111111111100001110000011100",
"1110001111110011100111000000111000011100001110011100000011100000111000111000",
"1110011101110011100111000000111000011100001110011100000011100000011101110000",
"1110111001110011100111000000111000011100001110011100000011100000001111100000",
"1111110001110011100111000000111000011100001110011100000011100000000111000000",
"1111100001110011100111000000111000011100001110011100000011100000000111000000",
"1111000001110011100111000000111000011100001110011100000011100000000111000000",
"1110000001110011100111000000111000011100001110011100000011100000000111000000",
"1110000001110011100111000000111000011100001110011100000011100000000111000000",
"1110000001110011100111001100111000011100001110011100000011100000000111000000",
"1110000001110011100111011110111000011100001110011100000011100000000111000000",
"1110000001110011100111110011111000011111111110011111111111100000000111000000",
"1110000001110011100111100001111000011111111110011111111111100000000111000000",
"1110000001110011100111000000111000011111111110011111111111100000000111000000"
);




signal rom_addr_WIN : unsigned (3 downto 0) ; 
signal rom_col_WIN : unsigned (7 downto 0) ; 
signal rom_data_WIN: std_logic_vector (75 downto 0) ; 
signal rom_bit_WIN : std_logic ; 
signal rd_WIN_on : std_logic; 
signal sq_WIN_on: std_logic;	
signal X_WIN : integer :=68;
signal Y_WIN : integer :=450;
signal WINNER: std_logic :='0';

-----------------------------------------------------------------------------------	
--Napis YOU LOSE
-----------------------------------------------------------------------------------
type rom_LOSE is array(0 to 15) of
 std_logic_vector(94 downto 0);
constant LOSE: rom_LOSE :=
(
"11111111110011111111110011111111111100000000000111000011100001110011111111111100111000000000111",
"11111111110011111111110011111111111100000000000111000011100001110011111111111100011100000001110",
"11111111110011111111110011111111111100000000000111000011100001110011111111111100001110000011100",
"00000001110000000001110011100000011100000000000111000011100001110011100000011100000111000111000",
"00000001110000000001110011100000011100000000000111000011100001110011100000011100000011101110000",
"00000001110000000001110011100000011100000000000111000011100001110011100000011100000001111100000",
"11111111110011111111110011100000011100000000000111000011100001110011100000011100000000111000000",
"11111111110011111111110011100000011100000000000111000011100001110011100000011100000000111000000",
"11111111110011111111110011100000011100000000000111000011100001110011100000011100000000111000000",
"00000001110011100000000011100000011100000000000111000011100001110011100000011100000000111000000",
"00000001110011100000000011100000011100000000000111000011100001110011100000011100000000111000000",
"00000001110011100000000011100000011100000000000111000011100001110011100000011100000000111000000",
"00000001110011100000000011100000011100000000000111000011100001110011100000011100000000111000000",
"11111111110011111111110011111111111100000000000111000011111111110011111111111100000000111000000",
"11111111110011111111110011111111111100111111111111000011111111110011111111111100000000111000000",
"11111111110011111111110011111111111100111111111111000011111111110011111111111100000000111000000"
);

signal rom_addr_LOSE : unsigned (3 downto 0) ; 
signal rom_col_LOSE : unsigned (7 downto 0) ; 
signal rom_data_LOSE: std_logic_vector (94 downto 0) ; 
signal rom_bit_LOSE : std_logic ; 
signal rd_LOSE_on : std_logic; 
signal sq_LOSE_on: std_logic;	
signal X_LOSE : integer :=68;
signal Y_LOSE : integer :=450;
signal LOSER: std_logic :='0';

begin 

--Warunek wyświetlania ścian labiryntu								
-----------------------------------------------------------------------------------------------------		

	wall_on <= 
		'1' when ((WALL_LEFT_X1<=h_count) and (h_count <= WALL_LEFT_X2)) or
					((WALL_RIGHT_X1<=h_count) and (h_count <= WALL_RIGHT_X2)) or
					((WALL_UP_Y1<=v_count) and (v_count <= WALL_UP_Y2)) or
					((WALL_DOWN_Y1 <=v_count) and (v_count <= WALL_DOWN_Y2)) or
					((WALL_LEFTUP_X1 <=h_count) and (h_count <= WALL_LEFTUP_X2) and(WALL_LEFTUP_Y1<=v_count)and(v_count <= WALL_LEFTUP_Y2)) or
					((WALL_RIGHTUP_X1 <=h_count) and (h_count <= WALL_RIGHTUP_X2) and(WALL_RIGHTUP_Y1<=v_count)and(v_count <= WALL_RIGHTUP_Y2)) or
					((WALL_LEFTDOWN_X1 <=h_count) and (h_count <= WALL_LEFTDOWN_X2) and(WALL_LEFTDOWN_Y1<=v_count)and(v_count <= WALL_LEFTDOWN_Y2)) or
					((WALL_RIGHTDOWN_X1 <=h_count) and (h_count <= WALL_RIGHTDOWN_X2) and(WALL_RIGHTDOWN_Y1<=v_count)and(v_count <= WALL_RIGHTDOWN_Y2))
		else '0';

--Warunki wyświetlania kulek po lewej stronie labiryntu
-----------------------------------------------------------------------------------------------------		


-- Warunki dla kul po lewej stronie labiryntu 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
sq_S_BALL_on_1 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_1 and v_count < Y_S_BALL_LEFTRIGHT_1 + 8 and h_count >= X_S_BALL_LEFT and h_count < X_S_BALL_LEFT + 8 and S_BALL_1 = '1') 
							 else '0';
				
sq_S_BALL_on_2 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_2 and v_count < Y_S_BALL_LEFTRIGHT_2 + 8 and h_count >= X_S_BALL_LEFT and h_count < X_S_BALL_LEFT + 8 and S_BALL_2 = '1') 
							 else '0';
							 
sq_S_BALL_on_3 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_3 and v_count < Y_S_BALL_LEFTRIGHT_3 + 8 and h_count >= X_S_BALL_LEFT and h_count < X_S_BALL_LEFT + 8 and S_BALL_3 = '1') 
							 else '0';

sq_S_BALL_on_4 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_4 and v_count < Y_S_BALL_LEFTRIGHT_4 + 8 and h_count >= X_S_BALL_LEFT and h_count < X_S_BALL_LEFT + 8 and S_BALL_4 = '1') 
							 else '0';

sq_S_BALL_on_5 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_5 and v_count < Y_S_BALL_LEFTRIGHT_5 + 8 and h_count >= X_S_BALL_LEFT and h_count < X_S_BALL_LEFT + 8 and S_BALL_5 = '1') 
							 else '0';
							 
-- Warunki dla kul po prawej stronie labiryntu	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					 
sq_S_BALL_on_6 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_1 and v_count < Y_S_BALL_LEFTRIGHT_1 + 8 and h_count >= X_S_BALL_RIGHT and h_count < X_S_BALL_RIGHT + 8 and S_BALL_6 = '1') 
							 else '0';
							 
sq_S_BALL_on_7 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_2 and v_count < Y_S_BALL_LEFTRIGHT_2 + 8 and h_count >= X_S_BALL_RIGHT and h_count < X_S_BALL_RIGHT + 8 and S_BALL_7 = '1') 
							 else '0';
							 
sq_S_BALL_on_8 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_3 and v_count < Y_S_BALL_LEFTRIGHT_3 + 8 and h_count >= X_S_BALL_RIGHT and h_count < X_S_BALL_RIGHT + 8 and S_BALL_8 = '1') 
							 else '0';
							 
sq_S_BALL_on_9 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_4 and v_count < Y_S_BALL_LEFTRIGHT_4 + 8 and h_count >= X_S_BALL_RIGHT and h_count < X_S_BALL_RIGHT + 8 and S_BALL_9 = '1') 
							 else '0';
							 
sq_S_BALL_on_10 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_5 and v_count < Y_S_BALL_LEFTRIGHT_5 + 8 and h_count >= X_S_BALL_RIGHT and h_count < X_S_BALL_RIGHT + 8 and S_BALL_10 = '1') 
							 else '0';
							
						
-- Warunki dla kul w lewym tunelu pionowym	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					
sq_S_BALL_on_11 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_1 and v_count < Y_S_BALL_LEFTRIGHT_1 + 8 and h_count >= X_S_BALL_MIDDLELEFT and h_count < X_S_BALL_MIDDLELEFT + 8 and S_BALL_11 = '1') 
							 else '0';
							 
sq_S_BALL_on_12 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_2 and v_count < Y_S_BALL_LEFTRIGHT_2 + 8 and h_count >= X_S_BALL_MIDDLELEFT and h_count < X_S_BALL_MIDDLELEFT + 8 and S_BALL_12 = '1') 
							 else '0';
							 
sq_S_BALL_on_13 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_3 and v_count < Y_S_BALL_LEFTRIGHT_3 + 8 and h_count >= X_S_BALL_MIDDLELEFT and h_count < X_S_BALL_MIDDLELEFT + 8 and S_BALL_13 = '1') 
							 else '0';
							 
-- Warunki dla kul w prawym tunelu pionowym
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
sq_S_BALL_on_14 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_4 and v_count < Y_S_BALL_LEFTRIGHT_4 + 8 and h_count >= X_S_BALL_MIDDLERIGHT and h_count < X_S_BALL_MIDDLERIGHT + 8 and S_BALL_14 = '1') 
							 else '0';
							 
sq_S_BALL_on_15 <= '1' when (v_count >= Y_S_BALL_LEFTRIGHT_5 and v_count < Y_S_BALL_LEFTRIGHT_5 + 8 and h_count >= X_S_BALL_MIDDLERIGHT and h_count < X_S_BALL_MIDDLERIGHT + 8 and S_BALL_15 = '1') 
							 else '0';
							 
-- Warunki dla kul w górnej części labiryntu	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------						 
sq_S_BALL_on_16 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_1 and h_count < X_S_BALL_UPMIDDLEDOWN_1 + 8 and S_BALL_16 = '1') 
							 else '0';
							 
sq_S_BALL_on_17 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_2 and h_count < X_S_BALL_UPMIDDLEDOWN_2 + 8 and S_BALL_17 = '1') 
							 else '0';
							 
sq_S_BALL_on_18 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_3 and h_count < X_S_BALL_UPMIDDLEDOWN_3 + 8 and S_BALL_18 = '1') 
							 else '0';
							 
sq_S_BALL_on_19 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_4 and h_count < X_S_BALL_UPMIDDLEDOWN_4 + 8 and S_BALL_19 = '1') 
							 else '0';
							 
sq_S_BALL_on_20 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_5 and h_count < X_S_BALL_UPMIDDLEDOWN_5 + 8 and S_BALL_20 = '1') 
							 else '0';
							 
sq_S_BALL_on_21 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_6 and h_count < X_S_BALL_UPMIDDLEDOWN_6 + 8 and S_BALL_21 = '1') 
							 else '0';
							 
sq_S_BALL_on_22 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_7 and h_count < X_S_BALL_UPMIDDLEDOWN_7 + 8 and S_BALL_22 = '1') 
							 else '0';
							 
sq_S_BALL_on_23 <= '1' when (v_count >= Y_S_BALL_UP and v_count < Y_S_BALL_UP + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_8 and h_count < X_S_BALL_UPMIDDLEDOWN_8 + 8 and S_BALL_23 = '1') 
							 else '0';
					
-- Warunki dla kul w środkowym tunelu poziomym
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
sq_S_BALL_on_24 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_1 and h_count < X_S_BALL_UPMIDDLEDOWN_1 + 8 and S_BALL_24 = '1') 
							 else '0';
							 
sq_S_BALL_on_25 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_2 and h_count < X_S_BALL_UPMIDDLEDOWN_2 + 8 and S_BALL_25 = '1') 
							 else '0';
							 
sq_S_BALL_on_26 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_3 and h_count < X_S_BALL_UPMIDDLEDOWN_3 + 8 and S_BALL_26 = '1') 
							 else '0';
							 
sq_S_BALL_on_27 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_4 and h_count < X_S_BALL_UPMIDDLEDOWN_4 + 8 and S_BALL_27 = '1') 
							 else '0';
							 
sq_S_BALL_on_28 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_5 and h_count < X_S_BALL_UPMIDDLEDOWN_5 + 8 and S_BALL_28 = '1') 
							 else '0';
							 
sq_S_BALL_on_29 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_6 and h_count < X_S_BALL_UPMIDDLEDOWN_6 + 8 and S_BALL_29 = '1') 
							 else '0';
							 
sq_S_BALL_on_30 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_7 and h_count < X_S_BALL_UPMIDDLEDOWN_7 + 8 and S_BALL_30 = '1') 
							 else '0';
							 
sq_S_BALL_on_31 <= '1' when (v_count >= Y_S_BALL_MIDDLE and v_count < Y_S_BALL_MIDDLE + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_8 and h_count < X_S_BALL_UPMIDDLEDOWN_8 + 8 and S_BALL_31 = '1') 
							 else '0';
					
-- Warunki dla kul w dolnej części labiryntu
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
sq_S_BALL_on_32 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_1 and h_count < X_S_BALL_UPMIDDLEDOWN_1 + 8 and S_BALL_32 = '1') 
							 else '0';
							 
sq_S_BALL_on_33 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_2 and h_count < X_S_BALL_UPMIDDLEDOWN_2 + 8 and S_BALL_33 = '1') 
							 else '0';
							 
sq_S_BALL_on_34 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_3 and h_count < X_S_BALL_UPMIDDLEDOWN_3 + 8 and S_BALL_34 = '1') 
							 else '0';
							 
sq_S_BALL_on_35 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_4 and h_count < X_S_BALL_UPMIDDLEDOWN_4 + 8 and S_BALL_35 = '1') 
							 else '0';
							 
sq_S_BALL_on_36 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_5 and h_count < X_S_BALL_UPMIDDLEDOWN_5 + 8 and S_BALL_36 = '1') 
							 else '0';
							 
sq_S_BALL_on_37 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_6 and h_count < X_S_BALL_UPMIDDLEDOWN_6 + 8 and S_BALL_37 = '1') 
							 else '0';
							 
sq_S_BALL_on_38 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_7 and h_count < X_S_BALL_UPMIDDLEDOWN_7 + 8 and S_BALL_38 = '1') 
							 else '0';
							 
sq_S_BALL_on_39 <= '1' when (v_count >= Y_S_BALL_DOWN and v_count < Y_S_BALL_DOWN + 8 and h_count >= X_S_BALL_UPMIDDLEDOWN_8 and h_count < X_S_BALL_UPMIDDLEDOWN_8 + 8 and S_BALL_39 = '1') 
							 else '0';
							 
							 
--Kod odpowiedzialny za wyłuskanie bitu z tablicy, który informuje czy piksel powinien zostać zapalony przy wyświetlaniu kulek							 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------							 
--Kod dla 5 kulek z lewej strony labiryntu
---------------------------------------------------------------
rom_addr_ball_1 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_1; 
rom_col_ball_1 <= h_count(2 downto 0) -  X_S_BALL_LEFT;

rom_data_ball_1 <= SMALL_BALL(to_integer(rom_addr_ball_1));
rom_bit_ball_1 <= rom_data_ball_1(to_integer(rom_col_ball_1));

rom_addr_ball_2 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_2; 
rom_data_ball_2 <= SMALL_BALL(to_integer(rom_addr_ball_2));
rom_bit_ball_2 <= rom_data_ball_2(to_integer(rom_col_ball_1));

rom_addr_ball_3 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_3; 
rom_data_ball_3 <= SMALL_BALL(to_integer(rom_addr_ball_3));
rom_bit_ball_3 <= rom_data_ball_3(to_integer(rom_col_ball_1));

rom_addr_ball_4 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_4; 
rom_data_ball_4 <= SMALL_BALL(to_integer(rom_addr_ball_4));
rom_bit_ball_4 <= rom_data_ball_4(to_integer(rom_col_ball_1));

rom_addr_ball_5 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_5; 
rom_data_ball_5 <= SMALL_BALL(to_integer(rom_addr_ball_5));
rom_bit_ball_5 <= rom_data_ball_5(to_integer(rom_col_ball_1));

--Kod dla 5 kulek z prawej strony labiryntu
---------------------------------------------------------------
rom_addr_ball_6 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_1; 
rom_col_ball_2 <= h_count(2 downto 0) -  X_S_BALL_RIGHT;

rom_data_ball_6 <= SMALL_BALL(to_integer(rom_addr_ball_6));
rom_bit_ball_6 <= rom_data_ball_6(to_integer(rom_col_ball_2));

rom_addr_ball_7 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_2; 
rom_data_ball_7 <= SMALL_BALL(to_integer(rom_addr_ball_7));
rom_bit_ball_7 <= rom_data_ball_7(to_integer(rom_col_ball_2));

rom_addr_ball_8 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_3; 
rom_data_ball_8 <= SMALL_BALL(to_integer(rom_addr_ball_8));
rom_bit_ball_8 <= rom_data_ball_8(to_integer(rom_col_ball_2));

rom_addr_ball_9 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_4; 
rom_data_ball_9 <= SMALL_BALL(to_integer(rom_addr_ball_9));
rom_bit_ball_9 <= rom_data_ball_9(to_integer(rom_col_ball_2));

rom_addr_ball_10 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_5; 
rom_data_ball_10 <= SMALL_BALL(to_integer(rom_addr_ball_10));
rom_bit_ball_10 <= rom_data_ball_10(to_integer(rom_col_ball_2));

--Kod dla 3 kulek w lewym tunelu pionowym
---------------------------------------------------------------
rom_addr_ball_11 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_1; 
rom_col_ball_3 <= h_count(2 downto 0) -  X_S_BALL_MIDDLELEFT;

rom_data_ball_11 <= SMALL_BALL(to_integer(rom_addr_ball_11));
rom_bit_ball_11 <= rom_data_ball_11(to_integer(rom_col_ball_3));

rom_addr_ball_12 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_2; 
rom_data_ball_12 <= SMALL_BALL(to_integer(rom_addr_ball_12));
rom_bit_ball_12 <= rom_data_ball_12(to_integer(rom_col_ball_3));

rom_addr_ball_13 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_3; 
rom_data_ball_13 <= SMALL_BALL(to_integer(rom_addr_ball_13));
rom_bit_ball_13 <= rom_data_ball_13(to_integer(rom_col_ball_3));

--Kod dla 2 kulek w prawym tunelu pionowym
---------------------------------------------------------------
rom_addr_ball_14 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_4; 
rom_col_ball_4 <= h_count(2 downto 0) -  X_S_BALL_MIDDLERIGHT;

rom_data_ball_14 <= SMALL_BALL(to_integer(rom_addr_ball_14));
rom_bit_ball_14 <= rom_data_ball_14(to_integer(rom_col_ball_4));

rom_addr_ball_15 <= v_count(2 downto 0) -  Y_S_BALL_LEFTRIGHT_5; 
rom_data_ball_15 <= SMALL_BALL(to_integer(rom_addr_ball_15));
rom_bit_ball_15 <= rom_data_ball_15(to_integer(rom_col_ball_4));

--Kod dla 8 kulek w górnej części labiryntu
---------------------------------------------------------------
rom_addr_ball_16 <= v_count(2 downto 0) -  Y_S_BALL_UP; 
rom_col_ball_5 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_1;

rom_data_ball_16 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_16 <= rom_data_ball_16(to_integer(rom_col_ball_5));

rom_col_ball_6 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_2; 
rom_data_ball_17 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_17 <= rom_data_ball_17(to_integer(rom_col_ball_6));

rom_col_ball_7 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_3; 
rom_data_ball_18 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_18 <= rom_data_ball_18(to_integer(rom_col_ball_7));

rom_col_ball_8 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_4; 
rom_data_ball_19 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_19 <= rom_data_ball_19(to_integer(rom_col_ball_8));

rom_col_ball_9 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_5; 
rom_data_ball_20 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_20 <= rom_data_ball_20(to_integer(rom_col_ball_9));

rom_col_ball_10 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_6;
rom_data_ball_21 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_21 <= rom_data_ball_21(to_integer(rom_col_ball_10));

rom_col_ball_11 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_7; 
rom_data_ball_22 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_22 <= rom_data_ball_22(to_integer(rom_col_ball_11));

rom_col_ball_12 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_8;
rom_data_ball_23 <= SMALL_BALL(to_integer(rom_addr_ball_16));
rom_bit_ball_23 <= rom_data_ball_23(to_integer(rom_col_ball_12));

--Kod dla 8 kulek w środkowym tunelu poziomym
---------------------------------------------------------------
rom_addr_ball_17 <= v_count(2 downto 0) -  Y_S_BALL_MIDDLE; 
rom_col_ball_13 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_1;

rom_data_ball_24 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_24 <= rom_data_ball_24(to_integer(rom_col_ball_13));

rom_col_ball_14 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_2; 
rom_data_ball_25 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_25 <= rom_data_ball_25(to_integer(rom_col_ball_14));

rom_col_ball_15 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_3; 
rom_data_ball_26 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_26 <= rom_data_ball_26(to_integer(rom_col_ball_15));

rom_col_ball_16 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_4;
rom_data_ball_27 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_27 <= rom_data_ball_27(to_integer(rom_col_ball_16));

rom_col_ball_17 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_5; 
rom_data_ball_28 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_28 <= rom_data_ball_28(to_integer(rom_col_ball_17));

rom_col_ball_18 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_6; 
rom_data_ball_29 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_29 <= rom_data_ball_29(to_integer(rom_col_ball_18));

rom_col_ball_19 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_7; 
rom_data_ball_30 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_30 <= rom_data_ball_30(to_integer(rom_col_ball_19));

rom_col_ball_20 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_8; 
rom_data_ball_31 <= SMALL_BALL(to_integer(rom_addr_ball_17));
rom_bit_ball_31 <= rom_data_ball_31(to_integer(rom_col_ball_20));

--Kod dla 8 kulek w dolnej części labiryntu
---------------------------------------------------------------
rom_addr_ball_18 <= v_count(2 downto 0) -  Y_S_BALL_DOWN; 
rom_col_ball_21 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_1;

rom_data_ball_32 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_32 <= rom_data_ball_32(to_integer(rom_col_ball_21));

rom_col_ball_22 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_2; 
rom_data_ball_33 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_33 <= rom_data_ball_33(to_integer(rom_col_ball_22));

rom_col_ball_23 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_3; 
rom_data_ball_34 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_34 <= rom_data_ball_34(to_integer(rom_col_ball_23));

rom_col_ball_24 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_4; 
rom_data_ball_35 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_35 <= rom_data_ball_35(to_integer(rom_col_ball_24));

rom_col_ball_25 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_5;
rom_data_ball_36 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_36 <= rom_data_ball_36(to_integer(rom_col_ball_25));

rom_col_ball_26 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_6;
rom_data_ball_37 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_37 <= rom_data_ball_37(to_integer(rom_col_ball_26));

rom_col_ball_27 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_7;
rom_data_ball_38 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_38 <= rom_data_ball_38(to_integer(rom_col_ball_27));

rom_col_ball_28 <= h_count(2 downto 0) -  X_S_BALL_UPMIDDLEDOWN_8; 
rom_data_ball_39 <= SMALL_BALL(to_integer(rom_addr_ball_18));
rom_bit_ball_39 <= rom_data_ball_39(to_integer(rom_col_ball_28));
---------------------------------------------------------------

rd_S_BALL_on_1 <=
						'1' when (sq_S_BALL_on_1='1' and rom_bit_ball_1 = '1' ) or
									(sq_S_BALL_on_2='1' and rom_bit_ball_2 = '1' ) or
									(sq_S_BALL_on_3='1' and rom_bit_ball_3 = '1') or
									(sq_S_BALL_on_4='1' and rom_bit_ball_4 = '1' ) or
									(sq_S_BALL_on_5='1' and rom_bit_ball_5 = '1' ) or 
									(sq_S_BALL_on_6='1' and rom_bit_ball_6 = '1' ) or
									(sq_S_BALL_on_7='1' and rom_bit_ball_7 = '1' ) or
									(sq_S_BALL_on_8='1' and rom_bit_ball_8 = '1' ) or
									(sq_S_BALL_on_9='1' and rom_bit_ball_9 = '1' ) or
									(sq_S_BALL_on_10='1' and rom_bit_ball_10 = '1' ) or
									(sq_S_BALL_on_11='1' and rom_bit_ball_11 = '1' ) or
									(sq_S_BALL_on_12='1' and rom_bit_ball_12 = '1' ) or
									(sq_S_BALL_on_13='1' and rom_bit_ball_13 = '1' ) or
									(sq_S_BALL_on_14='1' and rom_bit_ball_14 = '1' ) or
									(sq_S_BALL_on_15='1' and rom_bit_ball_15 = '1' ) or
									(sq_S_BALL_on_16='1' and rom_bit_ball_16 = '1' ) or
									(sq_S_BALL_on_17='1' and rom_bit_ball_17 = '1' ) or
									(sq_S_BALL_on_18='1' and rom_bit_ball_18 = '1' ) or
									(sq_S_BALL_on_19='1' and rom_bit_ball_19 = '1' ) or
									(sq_S_BALL_on_20='1' and rom_bit_ball_20 = '1' ) or
									(sq_S_BALL_on_21='1' and rom_bit_ball_21 = '1' ) or
									(sq_S_BALL_on_22='1' and rom_bit_ball_22 = '1' ) or
									(sq_S_BALL_on_23='1' and rom_bit_ball_23 = '1' ) or
									(sq_S_BALL_on_24='1' and rom_bit_ball_24 = '1' ) or
									(sq_S_BALL_on_25='1' and rom_bit_ball_25 = '1' ) or
									(sq_S_BALL_on_26='1' and rom_bit_ball_26 = '1' ) or
									(sq_S_BALL_on_27='1' and rom_bit_ball_27 = '1' ) or
									(sq_S_BALL_on_28='1' and rom_bit_ball_28 = '1' ) or
									(sq_S_BALL_on_29='1' and rom_bit_ball_29 = '1' ) or
									(sq_S_BALL_on_30='1' and rom_bit_ball_30 = '1' ) or
									(sq_S_BALL_on_31='1' and rom_bit_ball_31 = '1' ) or
									(sq_S_BALL_on_32='1' and rom_bit_ball_32 = '1' ) or
									(sq_S_BALL_on_33='1' and rom_bit_ball_33 = '1' ) or
									(sq_S_BALL_on_34='1' and rom_bit_ball_34 = '1' ) or
									(sq_S_BALL_on_35='1' and rom_bit_ball_35 = '1' ) or
									(sq_S_BALL_on_36='1' and rom_bit_ball_36 = '1' ) or
									(sq_S_BALL_on_37='1' and rom_bit_ball_37 = '1' ) or
									(sq_S_BALL_on_38='1' and rom_bit_ball_38 = '1' ) or
									(sq_S_BALL_on_39='1' and rom_bit_ball_39 = '1' )


									else '0';	

-----------------------------------------------------------------------------------------------------
--Kod odpowiedzialny za wyłuskanie bitu z tablicy, który informuje
-- czy piksel powinien zostać zapalony przy wyświetlaniu pac-mana	
-----------------------------------------------------------------------------------------------------		
sq_PACMAN_on <= '1' when V_count >= Y_PACMAN and
								 V_count < Y_PACMAN + 15 and
								 h_count >= X_PACMAN and
								 h_count < X_PACMAN + 15
								 else '0';
	
rom_addr_pacman <= v_count(3 downto 0) - Y_PACMAN;
rom_col_pacman <= h_count(3 downto 0) - X_PACMAN;

rom_data_pacman <= PACMAN_FULL(to_integer(rom_addr_pacman))  when PACMAN_K = "000"	 else
						 PACMAN_LEFT(to_integer(rom_addr_pacman))  when PACMAN_K = "001"   else
						 PACMAN_UP(to_integer(rom_addr_pacman))  	 when PACMAN_K = "010"   else
						 PACMAN_RIGHT(to_integer(rom_addr_pacman)) when PACMAN_K = "011"	 else
						 PACMAN_DOWN(to_integer(rom_addr_pacman))  when PACMAN_K = "100" ;

rom_bit_pacman <= rom_data_pacman(to_integer(rom_col_pacman));
		
rd_PACMAN_on <=
 '1' when (sq_PACMAN_on='1') and (rom_bit_pacman = '1') else '0';		
 
-----------------------------------------------------------------------------------------------------	
--Kod odpowiedzialny za wyłuskanie bitu z tablicy, który informuje czy piksel powinien zostać zapalony przy wyświetlaniu ducha	
-----------------------------------------------------------------------------------------------------		
sq_GHOST_on <= '1' when V_count >= Y_GHOST and V_count < Y_GHOST+16 and h_count >= X_GHOST and h_count < X_GHOST+16 else '0';	
rom_addr_ghost <= v_count(3 downto 0) - Y_GHOST;
rom_col_ghost <= h_count(3 downto 0) - X_GHOST;

rom_data_ghost <= GHOST(to_integer(rom_addr_ghost));
rom_bit_ghost <= rom_data_ghost(to_integer(rom_col_ghost));
		
rd_GHOST_on <=
 '1' when (sq_GHOST_on='1') and (rom_bit_ghost = '1') else '0';		 

-------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------- 
sq_P_on <= '1' when V_count >= LETTER_POSITION_Y and V_count < LETTER_POSITION_Y +32 and h_count >= LETTER_POSITION_P_X and h_count < LETTER_POSITION_P_X +32 else '0';	
rom_addr_P <= v_count(4 downto 0) - LETTER_POSITION_Y;
rom_col_P <= h_count(4 downto 0) - LETTER_POSITION_P_X;

rom_data_P <= P(to_integer(rom_addr_P));
rom_bit_P <= rom_data_P(to_integer(rom_col_P));
		
rd_P_on <=
 '1' when (sq_P_on='1') and (rom_bit_P = '1') else '0';
 
 
------------------------------------------------------------------------------------------------------- 
sq_A_on <= '1' when V_count >= LETTER_POSITION_Y and V_count < LETTER_POSITION_Y +32 and h_count >= LETTER_POSITION_A_X and h_count < LETTER_POSITION_A_X +32 else '0';	
rom_addr_A <= v_count(4 downto 0) - LETTER_POSITION_Y;
rom_col_A <= h_count(4 downto 0) - LETTER_POSITION_A_X;

rom_data_A <= A(to_integer(rom_addr_A));
rom_bit_A <= rom_data_A(to_integer(rom_col_A));
		
rd_A_on <=
 '1' when (sq_A_on='1') and (rom_bit_A = '1') else '0'; 
 
------------------------------------------------------------------------------------------------------- 
sq_C_on <= '1' when V_count >= LETTER_POSITION_Y and V_count < LETTER_POSITION_Y +32 and h_count >= LETTER_POSITION_C_X and h_count < LETTER_POSITION_C_X +32 else '0';	
rom_addr_C <= v_count(4 downto 0) - LETTER_POSITION_Y;
rom_col_C <= h_count(4 downto 0) - LETTER_POSITION_C_X;

rom_data_C <= C(to_integer(rom_addr_C));
rom_bit_C <= rom_data_C(to_integer(rom_col_C));
		
rd_C_on <=
 '1' when (sq_C_on='1') and (rom_bit_C = '1') else '0';

------------------------------------------------------------------------------------------------------- 
sq_POD_on <= '1' when V_count >= LETTER_POSITION_Y and V_count < LETTER_POSITION_Y +32 and h_count >= LETTER_POSITION_POD_X and h_count < LETTER_POSITION_POD_X +32 else '0';	
rom_addr_POD <= v_count(4 downto 0) - LETTER_POSITION_Y;
rom_col_POD <= h_count(4 downto 0) - LETTER_POSITION_POD_X;

rom_data_POD <= POD(to_integer(rom_addr_POD));
rom_bit_POD <= rom_data_POD(to_integer(rom_col_POD));
		
rd_POD_on <=
 '1' when (sq_POD_on='1') and (rom_bit_POD = '1') else '0';
------------------------------------------------------------------------------------------------------- 
sq_M_on <= '1' when V_count >= LETTER_POSITION_Y and V_count < LETTER_POSITION_Y +32 and h_count >= LETTER_POSITION_M_X and h_count < LETTER_POSITION_M_X +32 else '0';	
rom_addr_M <= v_count(4 downto 0) - LETTER_POSITION_Y;
rom_col_M <= h_count(4 downto 0) - LETTER_POSITION_M_X;

rom_data_M <= M(to_integer(rom_addr_M));
rom_bit_M <= rom_data_M(to_integer(rom_col_M));
		
rd_M_on <=
 '1' when (sq_M_on='1') and (rom_bit_M = '1') else '0';

------------------------------------------------------------------------------------------------------- 
sq_A2_on <= '1' when V_count >= LETTER_POSITION_Y and V_count < LETTER_POSITION_Y +32 and h_count >= LETTER_POSITION_A_X2 and h_count < LETTER_POSITION_A_X2 +32 else '0';	
rom_addr_A2 <= v_count(4 downto 0) - LETTER_POSITION_Y;
rom_col_A2 <= h_count(4 downto 0) - LETTER_POSITION_A_X2;

rom_data_A2 <= A(to_integer(rom_addr_A2));
rom_bit_A2 <= rom_data_A(to_integer(rom_col_A2));
		
rd_A2_on <=
 '1' when (sq_A2_on='1') and (rom_bit_A2 = '1') else '0';
 
------------------------------------------------------------------------------------------------------- 
sq_N_on <= '1' when V_count >= LETTER_POSITION_Y and V_count < LETTER_POSITION_Y +32 and h_count >= LETTER_POSITION_N_X and h_count < LETTER_POSITION_N_X +32 else '0';	
rom_addr_N <= v_count(4 downto 0) - LETTER_POSITION_Y;
rom_col_N <= h_count(4 downto 0) - LETTER_POSITION_N_X;

rom_data_N <= N(to_integer(rom_addr_N));
rom_bit_N <= rom_data_N(to_integer(rom_col_N));
		
rd_N_on <=
 '1' when (sq_N_on='1') and (rom_bit_N = '1') else '0';

-------------------------------------------------------------------------------------------------------
--Wyświetlanie napisu YOU WIN
-------------------------------------------------------------------------------------------------------
 
sq_WIN_on <= '1' when V_count >= Y_WIN and V_count < Y_WIN +16 and h_count >= X_WIN and h_count < X_WIN +78 else '0';	
rom_addr_WIN <= v_count(3 downto 0) - Y_WIN;
rom_col_WIN <= h_count(7 downto 0) - X_WIN;

rom_data_WIN <= WIN(to_integer(rom_addr_WIN));
rom_bit_WIN <= rom_data_WIN(to_integer(rom_col_WIN));
		
rd_WIN_on <=
 '1' when (sq_WIN_on='1') and (rom_bit_WIN = '1') and (WINNER = '1') else '0';
 
-------------------------------------------------------------------------------------------------------
--Wyświetlanie napisu YOU LOSE
-------------------------------------------------------------------------------------------------------
 
sq_LOSE_on <= '1' when V_count >= Y_LOSE and V_count < Y_LOSE +16 and h_count >= X_LOSE and h_count < X_LOSE +95 else '0';	
rom_addr_LOSE <= v_count(3 downto 0) - Y_LOSE;
rom_col_LOSE <= h_count(7 downto 0) - X_LOSE;

rom_data_LOSE <= LOSE(to_integer(rom_addr_LOSE));
rom_bit_LOSE <= rom_data_LOSE(to_integer(rom_col_LOSE));
		
rd_LOSE_on <=
 '1' when (sq_LOSE_on='1') and (rom_bit_LOSE = '1') and (LOSER = '1') else '0'; 
 
------------------------------------------------------------------------------------------------------- 
 
 
sq_HEART_1_on <= '1' when V_count >= LETTER_POSITION_HEART_Y and V_count < LETTER_POSITION_HEART_Y+16 and h_count >= LETTER_POSITION_HEART_1_X and h_count < LETTER_POSITION_HEART_1_X+16 else '0';	

sq_HEART_2_on <= '1' when V_count >= LETTER_POSITION_HEART_Y and V_count < LETTER_POSITION_HEART_Y+16 and h_count >= LETTER_POSITION_HEART_2_X and h_count < LETTER_POSITION_HEART_2_X+16 else '0';

sq_HEART_3_on <= '1' when V_count >= LETTER_POSITION_HEART_Y and V_count < LETTER_POSITION_HEART_Y+16 and h_count >= LETTER_POSITION_HEART_3_X and h_count < LETTER_POSITION_HEART_3_X+16 else '0';


rom_addr_HEART_1 <= v_count(3 downto 0) - LETTER_POSITION_HEART_Y;

rom_col_HEART_1 <= h_count(3 downto 0) - LETTER_POSITION_HEART_1_X;
rom_data_HEART_1 <= HEART(to_integer(rom_addr_HEART_1));
rom_bit_HEART_1 <= rom_data_HEART_1(to_integer(rom_col_HEART_1));

rom_col_HEART_2 <= h_count(3 downto 0) - LETTER_POSITION_HEART_2_X;
rom_data_HEART_2 <= HEART(to_integer(rom_addr_HEART_1));
rom_bit_HEART_2 <= rom_data_HEART_2(to_integer(rom_col_HEART_2));

rom_col_HEART_3 <= h_count(3 downto 0) - LETTER_POSITION_HEART_3_X;
rom_data_HEART_3 <= HEART(to_integer(rom_addr_HEART_1));
rom_bit_HEART_3 <= rom_data_HEART_3(to_integer(rom_col_HEART_3));
		
rd_HEART_1_on <=
 '1' when ((sq_HEART_1_on='1') and (rom_bit_HEART_1 = '1') and (HEART_1 = '1')) or
			((sq_HEART_2_on='1') and (rom_bit_HEART_2 = '1') and (HEART_2 = '1')) or
			((sq_HEART_3_on='1') and (rom_bit_HEART_3 = '1') and (HEART_3 = '1')) 
			else '0';		 

-------------------------------------------------------------------------------------------------------
 --Kod odpowiedzialny za wyłuskanie bitu z tablicy, który informuje czy piksel powinien zostać zapalony przy wyświetlaniu dużej kulki
-------------------------------------------------------------------------------------------------------		

sq_B_BALL_on <= '1' when V_count >= Y_B_BALL and V_count < Y_B_BALL+16 and h_count >= X_B_BALL and h_count < X_B_BALL+16 and B_BALL = '1' else '0';	
rom_addr_B_BALL <= v_count(3 downto 0) - Y_B_BALL;
rom_col_B_BALL <= h_count(3 downto 0) - X_B_BALL;

rom_data_B_BALL <= BIG_BALL(to_integer(rom_addr_B_BALL));
rom_bit_B_BALL <= rom_data_B_BALL(to_integer(rom_col_B_BALL));
		
rd_B_BALL_on <=
 '1' when (sq_B_BALL_on='1') and (rom_bit_B_BALL = '1') else '0';	
	 	
-------------------------------------------------------------------------------------------------------		
				
PLLmagisterska_inst : PLLmagisterska PORT MAP (
		inclk0	 => CLOCK_100MHz,
		c0	 => clock_25MHz
	);

	
	
-------------------------------------------------------------------------------------------------------
--Procesy odpowiedzialne za sterownik VGA
-------------------------------------------------------------------------------------------------------	
 process(clock_25MHz) -- licznik kolumn 
	begin 
		if rising_edge(clock_25MHz) then 
			if h_count<793 then
				h_count<=h_count+1;
			else
				h_count<=(others=>'0');
			end if; 
		end if; 
 end process; 
 
 process(H_SYNC) -- licznik wierszy 
	begin 
		if rising_edge(H_SYNC) then 
			if v_count<524 then
				v_count<=v_count+1; 
			else
				v_count<=(others=>'0');
			end if; 
		end if; 
 end process;
 
 process(clock_25MHz) -- impulsy synchronizacji 
	begin 
		if rising_edge(clock_25MHz) then 
			if (h_count>=660) and (h_count<=750) then
				H_SYNC<='0';
			else
				H_SYNC<='1';
			end if; 
			
			if (v_count>=491) and (v_count<=492) then
				V_SYNC<='0'; 
			else
				V_SYNC<='1';
			end if; 
		end if; 
 end process; 
 
 pixel_column<=h_count;
 pixel_row<=v_count; 
 video_on<='1' when 
 (h_count<640 and v_count<480) else '0'; -- wygaszanie 
 
-------------------------------------------------------------------------------------------------------
--Proces wyświetlania grafik
-------------------------------------------------------------------------------------------------------

process(clock_25MHz) -- generowanie sygnalow REDn, GRNn i BLUn 
 begin 
	if rising_edge(clock_25MHz) then 
		if wall_on = '1'  then 
			BLU <= RGB(2) and video_on;
		elsif  rd_PACMAN_on = '1' or rd_S_BALL_on_1    = '1'  then 
			GRN <= RGB(1) and video_on ;
			RED <= RGB(2) and video_on ;
		elsif  rd_B_BALL_on = '1'  then 
			GRN <= RGB(1) and video_on ;
		elsif  rd_GHOST_on = '1'  then 
			BLU <= RGB(1) and video_on ;
			RED <= RGB(2) and video_on ;
		elsif rd_B_BALL_on = '1'  then 
			GRN <= RGB(1) and video_on ;
		elsif rd_P_on = '1' or rd_A_on = '1' or rd_C_on = '1' or rd_M_on = '1' or
				rd_A2_on = '1' or rd_N_on = '1' or rd_POD_on = '1' or rd_HEART_1_on = '1' or rd_LOSE_on = '1' or rd_WIN_on = '1'  then 
			GRN <= RGB(0) and video_on ;
			BLU <= RGB(1) and video_on ;
			RED <= RGB(2) and video_on ;
		else 
			RED <= '0'; 
			GRN <= '0';
			BLU <= '0';
		end if;
	end if;
end process; 

-------------------------------------------------------------------------------------------------------
--Proces odpowiedzialny za przesuwanie się napisu w interfejsie rozgrywki
------------------------------------------------------------------------------------------------------- 
 
	process(clock_25MHz)
		begin 
			if rising_edge(clock_25MHz) then
				if COUNTER = 500000 then 
					LETTER_POSITION_P_X <= LETTER_POSITION_P_X +1;
					LETTER_POSITION_A_X <= LETTER_POSITION_A_X +1;
					LETTER_POSITION_C_X <= LETTER_POSITION_C_X +1;
					LETTER_POSITION_POD_X <= LETTER_POSITION_POD_X +1;
					LETTER_POSITION_M_X <= LETTER_POSITION_M_X +1;
					LETTER_POSITION_A_X2 <= LETTER_POSITION_A_X2 +1;
					LETTER_POSITION_N_X <= LETTER_POSITION_N_X +1;
					COUNTER <= 0;
					if LETTER_POSITION_N_X > 576 then
						LETTER_POSITION_N_X <= 30;
					elsif LETTER_POSITION_A_X2 > 576 then
						LETTER_POSITION_A_X2 <= 30;
					elsif LETTER_POSITION_M_X > 576 then
						LETTER_POSITION_M_X <= 30;
					elsif LETTER_POSITION_POD_X > 576 then
						LETTER_POSITION_POD_X <= 30;
					elsif LETTER_POSITION_C_X > 576 then
						LETTER_POSITION_C_X <= 30;
					elsif LETTER_POSITION_A_X > 576 then
						LETTER_POSITION_A_X <= 30;
					elsif LETTER_POSITION_P_X > 576 then
						LETTER_POSITION_P_X <= 30;
					end if;
				else
					COUNTER <= COUNTER + 1;
				end if;	
			end if;
	end  process;

-------------------------------------------------------------------------------------------------------
--Proces odpowiedzialny za status rozgrywki
------------------------------------------------------------------------------------------------------- 
	process(clock_25MHz)
		begin 	
			if reset = '0' then
				GAME_ON <= '1';
				WINNER <= '0';
				LOSER <= '0';
			elsif rising_edge(clock_25MHz) then
				if HEART_1 = '0' and HEART_2 = '0' and HEART_3 = '0' then 
					LOSER <= '1';
					GAME_ON <= '0';
				elsif  	S_BALL_1 = '0' and S_BALL_2 = '0' and S_BALL_3 = '0' and
							S_BALL_4 = '0' and S_BALL_5 = '0' and
							S_BALL_6 = '0' and S_BALL_7 = '0' and S_BALL_8 = '0' and
							S_BALL_9 = '0' and S_BALL_10 = '0' and
							S_BALL_11 = '0' and S_BALL_12 = '0' and S_BALL_13 = '0' and
							S_BALL_14 = '0' and S_BALL_15 = '0' and
							S_BALL_16 = '0' and S_BALL_17 = '0' and S_BALL_18 = '0' and
							S_BALL_19 = '0' and S_BALL_20 = '0' and
							S_BALL_21 = '0' and S_BALL_22 = '0' and S_BALL_23 = '0' and
							S_BALL_24 = '0' and S_BALL_25 = '0' and
							S_BALL_26 = '0' and S_BALL_27 = '0' and S_BALL_28 = '0' and
							S_BALL_29 = '0' and S_BALL_30 = '0' and
							S_BALL_31 = '0' and S_BALL_32 = '0' and S_BALL_33 = '0' and
							S_BALL_34 = '0' and S_BALL_35 = '0' and
							S_BALL_36 = '0' and S_BALL_37 = '0' and S_BALL_38 = '0' and
							S_BALL_39 = '0' 
							then
					WINNER <= '1';
					GAME_ON <= '0';
				end if;
			end if;
	end process;

-------------------------------------------------------------------------------------------------------
--Proces odpowiedzialny za obsługę żyć gracza
------------------------------------------------------------------------------------------------------- 
	process(reset, X_PACMAN, Y_PACMAN)
		begin 
			if reset = '0' then
				HEART_1 <= '1';
				HEART_2 <= '1';
				HEART_3 <= '1';
			elsif rising_edge(clock_25MHz) then
					if (X_PACMAN <= X_GHOST + 15 and
						Y_PACMAN <= Y_GHOST + 15) and
						(X_PACMAN + 15 >= X_GHOST and
						Y_PACMAN <= Y_GHOST + 15) and
						(X_PACMAN + 15 >= X_GHOST and
						Y_PACMAN + 15 >= Y_GHOST) and
						(X_PACMAN <= X_GHOST + 15 and
						Y_PACMAN + 15 >= Y_GHOST) then
							HEART_LOSS <='1';
					end if;

				if GAME_ON = '1' then
					if PACMAN_COUNTER = 5000000 then
						if HEART_LOSS = '1' then
							if HEART_1 = '1' and HEART_2 = '1' 
							and HEART_3 = '1' then
								HEART_1 <= '0';
								HEART_LOSS <= '0';
							elsif HEART_1 = '0'and HEART_2= '1' 
							and HEART_3 = '1' then
								HEART_2 <= '0';
								HEART_LOSS <= '0';
							elsif HEART_1 = '0' and HEART_2 = '0'
							and HEART_3 = '1' then
								HEART_3 <= '0';
								HEART_LOSS <= '0';
							end if;
						end if;
					end if;
				end if;
			end if;
	end process;

---------------------------------------------------------------------------------------
--Mechanika Poruszania się PAC-MANA
-----------------------------------------------------------------------------------------------	
	process(clock_25MHz)
		begin
			if reset = '0' then
				X_PACMAN <= 100;
				Y_PACMAN <= 65;
			elsif rising_edge(clock_25MHz) then
				if GAME_ON = '1' then
					
					if(PACMAN_COUNTER mod 1000000 = 0) then
						if (X_PACMAN <= X_GHOST + 15 and Y_PACMAN <= Y_GHOST + 15) and (X_PACMAN + 15 >= X_GHOST and Y_PACMAN <= Y_GHOST + 15) and (X_PACMAN + 15 >= X_GHOST and Y_PACMAN + 15 >= Y_GHOST) and (X_PACMAN <= X_GHOST + 15 and Y_PACMAN + 15 >= Y_GHOST) then
							X_PACMAN  <= 100;
							Y_PACMAN  <= 65;

						elsif PACMAN_WAY = 0 and
							((Y_PACMAN > WALL_UP_Y2 and  Y_PACMAN + 15 < WALL_LEFTUP_Y1) or
							(Y_PACMAN > WALL_LEFTUP_Y2 and Y_PACMAN + 15 < WALL_LEFTDOWN_Y1) or
							(Y_PACMAN > WALL_LEFTDOWN_Y2 and Y_PACMAN + 15 < WALL_DOWN_Y1 )) and 
							X_PACMAN > WALL_LEFT_X2 + 1  then
								X_PACMAN <= X_PACMAN - 1;
						elsif PACMAN_WAY = 1 and
							((X_PACMAN > WALL_LEFT_X2 and X_PACMAN + 15 < WALL_LEFTUP_X1) or	
							(X_PACMAN > WALL_LEFTUP_X2 and X_PACMAN + 15 < WALL_RIGHTUP_X1 and Y_PACMAN + 15 < WALL_LEFTDOWN_Y1 ) or	
							(X_PACMAN > WALL_LEFTDOWN_X2 and X_PACMAN + 15 < WALL_RIGHTDOWN_X1 and Y_PACMAN > WALL_RIGHTUP_Y2 +1) or	
							(X_PACMAN > WALL_RIGHTUP_X2 and X_PACMAN + 15 < WALL_RIGHT_X1)) and
							Y_PACMAN > WALL_UP_Y2 + 1  then
								Y_PACMAN <= Y_PACMAN - 1;
						elsif PACMAN_WAY = 2 and
							((Y_PACMAN > WALL_UP_Y2 and  Y_PACMAN + 15 < WALL_LEFTUP_Y1) or
							(Y_PACMAN > WALL_LEFTUP_Y2 and Y_PACMAN + 15 < WALL_LEFTDOWN_Y1) or
							(Y_PACMAN > WALL_LEFTDOWN_Y2 and Y_PACMAN + 15 < WALL_DOWN_Y1 )) and
							X_PACMAN + 15 < WALL_RIGHT_X1 - 1  then
								X_PACMAN <= X_PACMAN + 1;
						elsif PACMAN_WAY = 3 and
							((X_PACMAN > WALL_LEFT_X2 and X_PACMAN + 15 < WALL_LEFTUP_X1 ) or
							(X_PACMAN > WALL_LEFTUP_X2 and X_PACMAN + 15 < WALL_RIGHTUP_X1 and Y_PACMAN + 15 < WALL_LEFTDOWN_Y1 - 1) or
							(X_PACMAN > WALL_LEFTDOWN_X2 and X_PACMAN + 15 < WALL_RIGHTDOWN_X1 and Y_PACMAN > WALL_RIGHTUP_Y2 ) or
							(X_PACMAN > WALL_RIGHTUP_X2 and X_PACMAN + 15 < WALL_RIGHT_X1)) and 
							Y_PACMAN + 15 < WALL_DOWN_Y1 - 1 then
								Y_PACMAN <= Y_PACMAN + 1;
	
						else 
							X_PACMAN <=X_PACMAN;
							Y_PACMAN <=Y_PACMAN;
						end if;
					else 
							X_PACMAN <=X_PACMAN;
							Y_PACMAN <=Y_PACMAN;
					end if;			
		end if;
			
			end if;
				
	end process;
	
---------------------------------------------------------------------------------------
--Proces zmiany strony wyświetlania Pac-Mana
---------------------------------------------------------------------------------------
	process(clock_25MHz)
		begin
			if reset = '0' then
					PACMAN_K <= "011";
					PACMAN_COUNTER <= 0 ;
					PACMAN_Choice <= '0';
			elsif rising_edge(clock_25MHz) then
				if GAME_ON = '1' then
					if PACMAN_COUNTER = 5000000 then 
						if PACMAN_Choice = '1' then 
							if PACMAN_WAY = 0 then
								PACMAN_K <= "001";
								PACMAN_COUNTER <= 0 ;
								PACMAN_Choice <= '0';
							elsif PACMAN_WAY = 1 then
								PACMAN_K <= "010";
								PACMAN_COUNTER <= 0 ;
								PACMAN_Choice <= '0';
							elsif PACMAN_WAY = 2 then
								PACMAN_K <= "011";
								PACMAN_COUNTER <= 0 ;
								PACMAN_Choice <= '0';
							elsif PACMAN_WAY = 3 then
								PACMAN_K <= "100";
								PACMAN_COUNTER <= 0 ;
								PACMAN_Choice <= '0';
							end if;
						else
							PACMAN_Choice <= '1';
							PACMAN_COUNTER <= 0 ;
							PACMAN_K <= "000";
						end if;
					else 
						PACMAN_COUNTER <=  PACMAN_COUNTER + 1;	
					end if;
				end if;
			end if;
	end process;
	
---------------------------------------------------------------------------------------
--Proces odpowiedzialny za obsługę przycisków
---------------------------------------------------------------------------------------
	
	process (clock_25MHz)
		begin
			if reset = '0' then
				PACMAN_WAY <= 2;
			elsif rising_edge(clock_25MHz) then
				if GAME_ON = '1' then
					--Poruszanie się lewą stronę
					if BTN_L = '0' and BTN_R = '0' then
						if (Y_PACMAN + 15 < WALL_LEFTUP_Y1 or
							(Y_PACMAN  > WALL_LEFTUP_Y2 and
							Y_PACMAN + 15 < WALL_RIGHTDOWN_Y1 ) or
							Y_PACMAN > WALL_LEFTDOWN_Y2 ) and
							X_PACMAN > WALL_LEFT_X2 + 1 then
								PACMAN_WAY <= 0;
						end if;
					--Poruszanie się w górę
					elsif BTN_L = '1' and BTN_R = '0' then
						if (X_PACMAN + 15 < WALL_LEFTUP_X1 or
							(X_PACMAN > WALL_LEFTUP_X2 and
							X_PACMAN + 15 < WALL_RIGHTUP_X1 and
							Y_PACMAN < WALL_LEFTDOWN_Y1) or
							(X_PACMAN > WALL_LEFTDOWN_X2 and
							X_PACMAN + 15 < WALL_RIGHTDOWN_X1 and
							Y_PACMAN + 15 > WALL_RIGHTUP_Y2) or
							X_PACMAN > WALL_RIGHTUP_X2) and
							Y_PACMAN > WALL_UP_Y2 + 1 then
								PACMAN_WAY <= 1;
						end if;
					--Poruszanie się w prawą stronę
					elsif BTN_L = '1' and BTN_R = '1' then
						if (Y_PACMAN + 15 < WALL_LEFTUP_Y1 or
							(Y_PACMAN  > WALL_LEFTUP_Y2 and
							Y_PACMAN + 15 < WALL_LEFTDOWN_Y1 ) or
							Y_PACMAN > WALL_LEFTDOWN_Y2 ) and
							X_PACMAN < WALL_RIGHT_X1 then
								PACMAN_WAY <= 2;
						end if;
					--Poruszanie się w dół
					elsif BTN_L = '0' and BTN_R = '1'  then
						if (X_PACMAN + 15 < WALL_LEFTUP_X1 or
							(X_PACMAN > WALL_LEFTUP_X2 and
							X_PACMAN + 15 < WALL_RIGHTUP_X1 and
							Y_PACMAN +15 < WALL_LEFTDOWN_Y1 -2) or
							(X_PACMAN > WALL_LEFTDOWN_X2 and
							X_PACMAN + 15 < WALL_RIGHTDOWN_X1 and
							Y_PACMAN + 15 > WALL_RIGHTUP_Y2) or
							X_PACMAN > WALL_RIGHTUP_X2) and
							Y_PACMAN + 15 < WALL_DOWN_Y1 - 1 then
								PACMAN_WAY <= 3;
						end if;
					else 
						PACMAN_WAY <= PACMAN_WAY;
					end if;
				end if;
			end if;
	end process;

---------------------------------------------------------------------------------------
--Proces odpowiedzialny za znikanie i obsługę kulek na mapie
---------------------------------------------------------------------------------------

	process(clock_25MHz)
		begin 
			if reset = '0' then
				S_BALL_1 <= '1';S_BALL_2 <= '1';S_BALL_3 <= '1';S_BALL_4 <= '1';S_BALL_5 <= '1';S_BALL_6 <= '1';
				S_BALL_7 <= '1';S_BALL_8 <= '1';S_BALL_9 <= '1';S_BALL_10 <= '1';S_BALL_11 <= '1';S_BALL_12 <= '1';
				S_BALL_13 <= '1';S_BALL_14 <= '1';S_BALL_15 <= '1';S_BALL_16 <= '1';S_BALL_17 <= '1';S_BALL_18 <= '1';
				S_BALL_19 <= '1';S_BALL_20 <= '1';S_BALL_21 <= '1';S_BALL_22 <= '1';S_BALL_23 <= '1';S_BALL_24 <= '1';
				S_BALL_25 <= '1';S_BALL_26 <= '1';S_BALL_27 <= '1';S_BALL_28 <= '1';S_BALL_29 <= '1';S_BALL_30 <= '1';
				S_BALL_31 <= '1';S_BALL_32 <= '1';S_BALL_33 <= '1';S_BALL_34 <= '1';S_BALL_35 <= '1';S_BALL_36 <= '1';
				S_BALL_37 <= '1';S_BALL_38 <= '1';S_BALL_39 <= '1';
				
				B_BALL <= '1';
				ATTACK_ACTIVATION <= '0';
				
			elsif rising_edge(clock_25MHz) then 
				--Warunki znikania kulek z lewej strony labiryntu
				if (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_1 or
				Y_PACMAN = Y_S_BALL_LEFTRIGHT_1 + 7) and
				X_PACMAN < WALL_LEFTUP_X1 then
					S_BALL_1 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_2 or
				Y_PACMAN = Y_S_BALL_LEFTRIGHT_2 + 7) and
				X_PACMAN < WALL_LEFTUP_X1 then
					S_BALL_2 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_3 or
				Y_PACMAN = Y_S_BALL_LEFTRIGHT_3 + 7) and
				X_PACMAN < WALL_LEFTUP_X1 then
					S_BALL_3 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_4 or
				Y_PACMAN = Y_S_BALL_LEFTRIGHT_4 + 7) and
				X_PACMAN < WALL_LEFTUP_X1 then
					S_BALL_4 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_5 or
				Y_PACMAN = Y_S_BALL_LEFTRIGHT_5 + 7) and
				X_PACMAN < WALL_LEFTUP_X1 then
					S_BALL_5 <= '0';
					
				--Warunki znikania kulek z prawej strony labiryntu
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_1 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_1 + 7) and X_PACMAN > WALL_RIGHTUP_X2 then
					S_BALL_6 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_2 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_2 + 7) and X_PACMAN > WALL_RIGHTUP_X2 then
					S_BALL_7 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_3 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_3 + 7) and X_PACMAN > WALL_RIGHTUP_X2 then
					S_BALL_8 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_4 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_4 + 7) and X_PACMAN > WALL_RIGHTUP_X2 then
					S_BALL_9 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_5 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_5 + 7) and X_PACMAN > WALL_RIGHTUP_X2 then
					S_BALL_10 <= '0';
				
				--Warunki znikania kulek w lewym tunelu pionowym
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_1 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_1 + 7) and X_PACMAN > WALL_LEFTUP_X2 and X_PACMAN < WALL_RIGHTUP_X1 then
					S_BALL_11 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_2 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_2 + 7) and X_PACMAN > WALL_LEFTUP_X2 and X_PACMAN < WALL_RIGHTUP_X1 then
					S_BALL_12 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_3 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_3 + 7) and X_PACMAN > WALL_LEFTUP_X2 and X_PACMAN < WALL_RIGHTUP_X1 then
					S_BALL_13 <= '0';
				
				--Warunki znikania kulek w prawym tunelu pionowym	
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_4 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_4 + 7) and X_PACMAN > WALL_LEFTDOWN_X2 and X_PACMAN < WALL_RIGHTDOWN_X1 then
					S_BALL_14 <= '0';
				elsif (Y_PACMAN + 15 = Y_S_BALL_LEFTRIGHT_5 or Y_PACMAN = Y_S_BALL_LEFTRIGHT_5 + 7) and X_PACMAN > WALL_LEFTDOWN_X2 and X_PACMAN < WALL_RIGHTDOWN_X1 then
					S_BALL_15 <= '0';
				
				--Warunki znikania kulek z górnej strony labiryntu
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_1 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_1 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_16 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_2 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_2 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_17 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_3 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_3 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_18 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_4 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_4 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_19 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_5 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_5 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_20 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_6 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_6 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_21 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_7 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_7 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_22 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_8 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_8 + 7) and Y_PACMAN < WALL_LEFTUP_Y1 then
					S_BALL_23 <= '0';
					
				--Warunki znikania kulek ze środkowego tunelu poziomego
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_1 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_1 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_24 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_2 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_2 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_25 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_3 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_3 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_26 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_4 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_4 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_27 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_5 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_5 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_28 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_6 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_6 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_29 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_7 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_7 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_30 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_8 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_8 + 7) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					S_BALL_31 <= '0';
				
				--Warunki znikania kulek z dolnej strony labiryntu
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_1 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_1 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_32 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_2 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_2 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_33 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_3 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_3 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_34 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_4 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_4 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_35 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_5 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_5 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_36 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_6 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_6 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_37 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_7 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_7 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_38 <= '0';
				elsif (X_PACMAN + 15 = X_S_BALL_UPMIDDLEDOWN_8 or X_PACMAN = X_S_BALL_UPMIDDLEDOWN_8 + 7) and Y_PACMAN > WALL_LEFTDOWN_X2 then
					S_BALL_39 <= '0';
				--Warunek znikania dużej kuli oraz aktywacja ataku 
				elsif (X_PACMAN + 15 = X_B_BALL or X_PACMAN = X_B_BALL + 15 ) and Y_PACMAN < WALL_LEFTDOWN_Y1 and Y_PACMAN > WALL_LEFTUP_X2 then
					B_BALL <= '0';
					ATTACK_ACTIVATION <= '1';
				end if;
			end if;
	end process;
	
---------------------------------------------------------------------------------------	
--Proces aktywacji dużej kulki	
---------------------------------------------------------------------------------------
	process(clock_25MHz)
		begin 
			if reset = '0' then
				COUNTER_BIG_BALL <= 0;
				ATTACK <= '0';
			elsif rising_edge(clock_25MHz) then 
				if ATTACK_ACTIVATION = '1' then
					if COUNTER_BIG_BALL < 300000000 then 
						ATTACK <= '1';
						COUNTER_BIG_BALL <= COUNTER_BIG_BALL + 1;
					else
						ATTACK <= '0';
					end if;
				end if;
			end if;
	end process;

 --Mrygranie diody przyciskiem
 ---------------------------------------------------------------
     process(BTN_L)
    begin
        if BTN_L = '1'  then
            dioda <= '1';
            
        else
            dioda <= '0';
        end if;

    end process;
 
-------------------------------------------------------------------------------------------------------
--Proces odpowiedzialny za poruszanie się ducha 
-------------------------------------------------------------------------------------------------------
	process (clock_25MHz)
		begin 
		
			if reset = '0'  then
					X_GHOST  <= 560;
					Y_GHOST  <= 384;
		
			elsif rising_edge(clock_25MHz) then 
				if GAME_ON = '1' then
					if(PACMAN_COUNTER mod 1000000 = 0) then
						if (X_PACMAN <= X_GHOST + 15 and Y_PACMAN <= Y_GHOST + 15)
						and (X_PACMAN + 15 >= X_GHOST and Y_PACMAN <= Y_GHOST + 15)
						and (X_PACMAN + 15 >= X_GHOST and Y_PACMAN + 15 >= Y_GHOST)
						and (X_PACMAN <= X_GHOST + 15 and Y_PACMAN + 15 >= Y_GHOST) then
							X_GHOST  <= 560;
							Y_GHOST  <= 384;
						elsif ATTACK = '0' then	
						--poruszanie w gore, jezeli pacman jest wyzej
							if Y_PACMAN  < Y_GHOST  and 
							(X_GHOST + 15 < WALL_LEFTUP_X1 or X_GHOST > WALL_RIGHTUP_X2 or
							(X_GHOST > WALL_LEFTUP_X2 and X_GHOST + 15  < WALL_RIGHTUP_X1 and
							Y_GHOST + 15 < WALL_LEFTDOWN_Y1 ) or (X_GHOST > WALL_LEFTDOWN_X2 and
							X_GHOST + 15 < WALL_RIGHTDOWN_X1 and Y_GHOST > WALL_RIGHTUP_Y2 + 1 )  )
							and Y_GHOST > WALL_UP_Y2  then
					
								Y_GHOST <= Y_GHOST - 1;

						--poruszanie w lewo, jezeli pacman jest z lewej
							elsif X_PACMAN < X_GHOST   and (Y_GHOST + 15 < WALL_LEFTUP_Y1 or
							(Y_GHOST > WALL_LEFTUP_Y2 and Y_GHOST + 15 < WALL_LEFTDOWN_Y1) or
							Y_GHOST > WALL_LEFTDOWN_Y2 ) and X_GHOST > WALL_LEFT_X2  then 
								X_GHOST <= X_GHOST - 1;	
						
						--poruszanie w dó, jezeli pacman jest  niżej 
							elsif Y_PACMAN > Y_GHOST   and (X_GHOST + 15 < WALL_LEFTUP_X1 or
							X_GHOST > WALL_RIGHTUP_X2 or (X_GHOST > WALL_LEFTUP_X2 and
							X_GHOST + 15  < WALL_RIGHTUP_X1 and Y_GHOST + 15 < WALL_LEFTDOWN_Y1 - 1 ) 
							or (X_GHOST > WALL_LEFTDOWN_X2 and X_GHOST + 15 < WALL_RIGHTDOWN_X1 and
							Y_GHOST > WALL_RIGHTUP_Y2)) and Y_GHOST < WALL_DOWN_Y1  then
								Y_GHOST <= Y_GHOST + 1;
						--poruszanie w prawo, jeżeli pacman jest z 
							elsif X_PACMAN > X_GHOST   and (Y_GHOST + 15 < WALL_LEFTUP_Y1 or
							(Y_GHOST > WALL_LEFTUP_Y2 and Y_GHOST + 15 < WALL_LEFTDOWN_Y1 ) or
							Y_GHOST > WALL_LEFTDOWN_Y2 ) and X_GHOST + 15 < WALL_RIGHT_X1  then 
								X_GHOST <= X_GHOST + 1;	
							else 
								X_GHOST <= X_GHOST ;
							end if;
						elsif ATTACK = '1' then

								X_GHOST <= X_GHOST ;
					else
						X_GHOST <= X_GHOST ;
					end if;
				end if;
			end if;
		end if;
	end process;
	

	
	
	
	
end beh; 
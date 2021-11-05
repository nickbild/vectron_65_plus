import os


os.remove("teensy_rom/teensy_rom.ino")
f = open("teensy_rom/teensy_rom.ino", "a")

###
# Print Arduino code.
###

f.write("""/*
Pin |  GPIO Reg  |  PWM timer
----|------------|-------------
01  |  GPIO6_02  |  FLEX_PWM1 
00  |  GPIO6_03  |  FLEX_PWM1 
24  |  GPIO6_12  |  FLEX_PWM1 
25  |  GPIO6_13  |  FLEX_PWM1 
19  |  GPIO6_16  |  QUAD3     
18  |  GPIO6_17  |  QUAD3     
14  |  GPIO6_18  |  QUAD3     
15  |  GPIO6_19  |  QUAD3     
17  |  GPIO6_22  |  no pwm    
16  |  GPIO6_23  |  no pwm    
22  |  GPIO6_24  |  FLEX_PWM4 
23  |  GPIO6_25  |  FLEX_PWM4 
20  |  GPIO6_26  |  no pwm    
21  |  GPIO6_27  |  no pwm    
26  |  GPIO6_30  |  no pwm    
27  |  GPIO6_31  |  no pwm    
10  |  GPIO7_00  |  QUAD1     
12  |  GPIO7_01  |  QUAD1     
11  |  GPIO7_02  |  QUAD1     
13  |  GPIO7_03  |  QUAD2     
06  |  GPIO7_10  |  FLEX_PWM2 
09  |  GPIO7_11  |  FLEX_PWM2 
32  |  GPIO7_12  |  no pwm    
08  |  GPIO7_16  |  FLEX_PWM1 
07  |  GPIO7_17  |  FLEX_PWM1 
37  |  GPIO8_12  |  FLEX_PWM1 
36  |  GPIO8_13  |  FLEX_PWM1 
35  |  GPIO8_14  |  FLEX_PWM1 
34  |  GPIO8_15  |  FLEX_PWM1 
39  |  GPIO8_16  |  FLEX_PWM1 
38  |  GPIO8_17  |  FLEX_PWM1 
28  |  GPIO8_18  |  FLEX_PWM3 
31  |  GPIO8_22  |  no pwm    
30  |  GPIO8_23  |  no pwm    
02  |  GPIO9_04  |  FLEX_PWM4 
03  |  GPIO9_05  |  FLEX_PWM4 
04  |  GPIO9_06  |  FLEX_PWM2 
33  |  GPIO9_07  |  FLEX_PWM2 
05  |  GPIO9_08  |  FLEX_PWM2 
29  |  GPIO9_31  |  FLEX_PWM3 
*/

int rom_contents[32768] = {};
uint16_t addr;
uint16_t temp;

void setup() {
  // Address bus.  A0-A14.
  pinMode(1, INPUT);
  pinMode(0, INPUT);
  pinMode(24, INPUT);
  pinMode(25, INPUT);
  pinMode(19, INPUT);
  pinMode(18, INPUT);
  pinMode(14, INPUT);
  pinMode(15, INPUT);
  pinMode(17, INPUT);
  pinMode(16, INPUT);
  pinMode(22, INPUT);
  pinMode(23, INPUT);
  pinMode(20, INPUT);
  pinMode(21, INPUT);
  pinMode(26, INPUT);

  // Data bus.  D0-D7.
  pinMode(10, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(32, OUTPUT);
  pinMode(8, OUTPUT);

  // Populate simulated ROM.
  setup_rom_contents();
}

void loop() {
  // Stitch address together from register bits.
  // GPIO6: xAxxAAAAAAxxAAAAxxAAxxxxxxxxAAxx
  addr = (GPIO6_DR & (1 << 30)) >> 30;

  addr = addr << 6;
  temp = (GPIO6_DR & (63 << 22)) >> 22;
  addr = addr + temp;
  
  addr = addr << 4;
  temp = (GPIO6_DR & (15 << 16)) >> 16;
  addr = addr + temp;
  
  addr = addr << 2;
  temp = (GPIO6_DR & (3 << 12)) >> 12;
  addr = addr + temp;
  
  addr = addr << 2;
  temp = (GPIO6_DR & (3 << 2)) >> 2;
  addr = addr + temp;

  // Set data bus.
  GPIO7_DR = rom_contents[addr];
}

void setup_rom_contents() {
  // ROM contents values must be preprocessed to fit into GPIO7.
  // (bit 8) DxxxDDDxxxxxxDDDD (bit 0)
  
  // NMI Interrupt address.
  // little endian
  rom_contents[32762] = 0;
  rom_contents[32763] = 0;

  // Starting address of program (write to FFFC-FFFD).
  // little endian
  rom_contents[32764] = 0;
  rom_contents[32765] = 65536; // 128

  // Interrupt address.
  // little endian
  rom_contents[32766] = 0;
  rom_contents[32767] = 0;

   // Program, starting at ROM address 0.
""")

###
# Generate/print ROM program.
###

os.system("xxd -p -s 32768 a.out > hex_auto.txt")

cnt = 0
data = ""
for line in open("hex_auto.txt"):
    for i in range(0, len(line)-1, 2):
        hex = line[i:i+2]
        
        # GPIO7: DxxxDDDxxxxxxDDDD
        b = "{0:b}".format(int(hex, 16)).zfill(8)
        b_reg = "{0}000{1}{2}{3}000000{4}{5}{6}{7}".format(b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7])

        f.write("\trom_contents[{0}] = {1};\t\t// Actual: {2}\n".format(cnt, int(b_reg, 2), int(hex, 16)))
        cnt += 1

# Finish Arduino code.
f.write("}\n")

f.close()

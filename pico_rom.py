import os

os.system("xxd -p -s 32768 a.out > hex_auto.txt")

cnt = 0
data = ""
for line in open("hex_auto.txt"):
	for i in range(0, len(line)-1, 2):
		hex = line[i:i+2]
		print("rom_contents[{0}] = {1};".format(cnt, str(int(hex, 16))))
		cnt += 1

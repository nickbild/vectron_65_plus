~/software/dasm os_vvga.asm -los.list -f3
echo ""
python3 bytes_list.py
python3 teensy_rom.py

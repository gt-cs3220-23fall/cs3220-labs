rm -rf 01.txt 02.txt 03.txt 04.txt 05.txt 06.txt 07.txt 08.txt 09.txt 10.txt 11.txt 12.txt 13.txt 14.txt

make systolic_array ROWS=4 COLS=4 K=4 NUM_TESTS=1000
cat results.log | grep PASSED 
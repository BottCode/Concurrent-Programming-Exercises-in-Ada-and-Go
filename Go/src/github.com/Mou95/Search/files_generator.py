import string
import random

alpha = 'abcdefg'
f = open("file_3.txt", "w+")

for i in range(10000):
    f.write(''.join(random.choice(alpha) for _ in range(7))+" ")

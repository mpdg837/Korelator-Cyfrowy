import io
import numpy
import matplotlib.pyplot as plt

file = open("received8.txt","r")
dane = []

for elementy in file:
    try:
        liczba = float(elementy)
        dane.append(liczba)
    except:
        print("",end="")

file.close()

print("Loaded")

for n,elementy in enumerate(dane):
    val = int(elementy*128)
    dane[n]=val


n=0
plt.ylim(-128,128)
plt.plot(dane[0:200])
plt.ylabel('SygnałP')

plt.show()


while n<len(dane)-3:
    sre = (dane[n]+dane[n+1]+dane[n+2]+dane[n+3]+dane[n+4])/5

    dane[n+1]=sre;
    dane[n + 2] = sre;
    dane[n] = sre;
    dane[n+3] = sre;
    dane[n + 4] = sre;

    n=n+5

lastval = 0
nextval = 0

n=0
while n<len(dane)-5:
    if n-1 > 0:
        lastval = dane[n-1]

    if n+4 < len(dane):
        nextval = dane[n+5]

    sr0=(lastval+dane[n+2])/2
    sr1 = (nextval+dane[n+2])/2

    dane[n]=(sr0+lastval)/2
    dane[n+1] = (sr0 + dane[n+2]) / 2
    dane[n + 3] = (sr1 + dane[n + 2]) / 2
    dane[n + 4] = (sr1 + nextval) / 2
    n=n+5

for n,elementy in enumerate(dane):
    val = int(elementy)
    dane[n]=val

linie = []
for n,elementy in enumerate(dane):
    pos = elementy*128
    linia = ""
    for x in range(256):
        npos = 128 - x
        if pos <npos+0.5 and pos >npos-0.5:
            linia = linia +"X"
        else:
            linia = linia + " "

    linie.append(linia)

print("Unghosted")
file = open("conv.txt","w")
text=""
for elementy in linie:
    text = text + elementy + "\n"

file.write(text)
file.close()


plt.plot(dane[0:5000])
plt.ylim(-128,128)
plt.ylabel('Sygnał')
plt.show()

print("Finished")


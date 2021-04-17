import io
import numpy
import matplotlib.pyplot as plt
from scipy.fftpack import rfft,rfftfreq
import math

file = open("received8.txt","r")
dane = []

for elementy in file:
    try:
        liczba = float(elementy)
        dane.append(liczba)
    except:
        print("",end="")

file.close()

energia=[]
lista=[]

for x in range(20):
    lista.append([])
    energia.append(0)

for n in range(len(dane)-20):

    fig = plt.figure()

    analizowany = dane[n:n+20]

    przeanal = rfft(analizowany)

    zbior =[]
    print("==")
    procent = n/(len(dane)-20)*100

    print(str(n)+") Loaded "+ str(int(procent))+" %")

    for p,elementy in enumerate(przeanal):
        zbior.append(numpy.abs(elementy))
        energia[p]=energia[p]+numpy.abs(elementy)
        lista[p].append(numpy.abs(elementy))

    plt.ylim([0, 6])

    odl = 375000+n*0.15;
    plt.title(str(odl) +" km")
    xf = rfftfreq(20, 1 / 1000000)

    plt.plot(xf,zbior)
    fig.savefig(r"E:\SYCYF\ODL" + str(n) + ".png")

    plt.close()
    
dziedzina = []
wynik = 750000
for n in range(len(lista[0])):
    dziedzina.append(wynik)
    wynik = wynik + 0.150

for x in range(20):
    fig = plt.figure()

    plt.ylim([0,6])
    plt.title(str(x*25)+" kHz" )

    plt.plot(dziedzina,lista[x])
    fig.savefig(r"E:\SYCYF\ANA"+str(x)+".png")

    plt.close()

fig = plt.figure()

plt.ylim([0,6])
plt.title("EEE")

plt.plot(energia)
fig.savefig(r"E:\SYCYF\ANAE.png")

plt.close()
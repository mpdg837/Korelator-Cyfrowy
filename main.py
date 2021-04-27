import io
import math

import matplotlib.pyplot as plt
import numpy as np


def pobierzdane(plik):
    file = open(plik, "r")
    dane = []

    for elementy in file:
        try:
            liczba = float(elementy)
            dane.append(liczba)
        except:
            print("", end="")

    file.close()
    return dane

received = pobierzdane("received8.txt")
sent = pobierzdane("sent8.txt")

korelacja = np.convolve(received,sent)


fig = plt.figure()

plt.plot(korelacja)

plt.show()

n = 0;
for probka in korelacja:
    if math.fabs(probka) > 2.5:
        print("Zarejestrowano sygnał w próbce nr "+str(n))
        break
    n= n + 1
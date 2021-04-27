import io
import matplotlib.pyplot as plt
import math

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

odp = []

for n in range(len(received)):
    suma = 0;

    for k in range(n-len(sent),n):

        k_bezwzgledne = k - (n-len(sent))

        if k >= 0:
            suma += received[k] * sent[k_bezwzgledne]

    odp.append(suma)

fig = plt.figure()

plt.plot(odp)

plt.show()

n = 0;
for probka in odp:
    if math.fabs(probka) > 4:
        print("Zarejestrowano sygnał w próbce nr "+str(n))
        break
    n= n + 1
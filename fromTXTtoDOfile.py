
linijki = []

def decimalToBinary(n):
    return bin(n).replace("0b", "")

def presentValue(el,num,name):
    value = int(el * 128);
    tex = ""

    if value >= 0:
        tex = decimalToBinary(value) + ""
    else:
        tex = decimalToBinary(value & 0xff) + ""
    for n in range(8 - len(tex)):
        tex = "0" + tex

    time = num * 40
    linijki.append("force "+name+" " + tex + " " + str(time))

def presentValueSIN(el,num,name,n):
    value = int(el * 128);
    tex = ""

    if value >= 0:
        tex = decimalToBinary(value) + ""
    else:
        tex = decimalToBinary(value & 0xff) + ""
    for n in range(8 - len(tex)):
        tex = "0" + tex

    time = num * 40 + n*2;

    linijki.append(r"5'd" + str(n) + r": n_con = r_con + (sel_sig *" + tex+");" )

plik = open(r"received8.txt","r")
plik2 = open(r"sent8.txt","r")


lista= []
listasin= []

for elementy in plik:
    try:
        lista.append(float(elementy))
    except Exception :
        print("")

for elementy in plik2:
    try:
        listasin.append(float(elementy))
    except Exception :
        print("")

plik.close()
plik2.close()

num = 0
sinn = 0
linijki.append(r"restart -nowave -force")
linijki.append(r"add wave *")

lin = 0
for el in lista:


    presentValue(el,num,"rec")
    print(el * 128)

    sinn = sinn + 1
    if sinn >19 :
        sinn = 0

    for o in range(20):
        l1 = o*2
        l2 = l1 + 1

        linijki.append("force clk 1 " + str(num*40 + l1))
        linijki.append("force clk 0 " + str(num*40 + l2))



    num = num + 1

for oss in range(0, 20):
    presentValueSIN(listasin[oss], num, "sin", oss)

linijki.append("run " + str(num*40+40))
write = open("output.txt","w")
for linia in linijki:
    write.write(linia+"\n")

write.close()

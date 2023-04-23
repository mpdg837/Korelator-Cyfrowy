Uwaga !!! Projekt jest dalszym rozwojem projeku zaliczeniowego z jednego z przedmiotów zaliczeniowych na studiach. Do tamtej realizacji dodano interacje z procesorem oraz dodano możliwość korzystania przez moduły z DMA. Do tego celu wykorzystano procesor NIOS/2e.

# Korelator-Cyfrowy
Celem projektu było stworzenie systemu SOC, który miałby być układem pomiarowym dla mierzenia odległości Ziemia-Księżyc. System ten miał otrzymać dane zgodne z poniższymi założeniami:

Najpierw  wciągu nieznanego czasu t0 wysłano wiązkę laserową zmodulowaną sygnalem sinusoidy z szybkością 10^6 próbek/sekunde. Sygnał ten miał okres T = 20 próbek (sinus o częstotliwości 50 kHz). Następnie odczekano 2.5 sekund po czym przez 5 ms z szybkością 10^6 próbek na sekunde i rozdzielczością 8 bitów/próbkę. Na podstawie odebranego sygnału należało doprecyzować odległość. 

Dla t = 2.5 ms odbite światło płynie przez 375000 km. Układ ten miał doprecyzować z precyzją do poniżej 1 km wspomnianą odległość. Schemat układu znajduje się poniżej.

<p align='center'>
<img src="https://github.com/mpdg837/Korelator-Cyfrowy/blob/main/Conclover.png"  width="800" height="400">
</p>

Port UART wychodzący z lasera ma prędkość zaledwie (a dla standardu UART aż) 100 kb/s (gdyż wykorzystano prędkość 1,22 Mbaud). Założono że pomiar 5 ms został zbuforowany i po odebraniu przesłany z mniejszą prędkością.
 

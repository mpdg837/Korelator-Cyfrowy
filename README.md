Uwaga !!! Projekt jest dalszym rozwojem projeku zaliczeniowego z jednego z przedmiotów zaliczeniowych na studiach. Do tamtej realizacji dodano interacje z procesorem oraz dodano możliwość korzystania przez moduły z DMA. Do tego celu wykorzystano procesor NIOS/2e. Opis tamtej części projektu zawarty jest w pliku pdf w tym repozytorium

# Korelator-Cyfrowy
Celem projektu było stworzenie systemu SOC, który miałby być układem pomiarowym dla mierzenia odległości Ziemia-Księżyc. System ten miał otrzymać dane zgodne z poniższymi założeniami:

Najpierw  wciągu nieznanego czasu t0 wysłano wiązkę laserową zmodulowaną sygnalem sinusoidy z szybkością 10^6 próbek/sekunde. Sygnał ten miał okres T = 20 próbek (sinus o częstotliwości 50 kHz). Następnie odczekano 2.5 sekund po czym przez 5 ms z szybkością 10^6 próbek na sekunde i rozdzielczością 8 bitów/próbkę. Na podstawie odebranego sygnału należało doprecyzować odległość. 

Dla t = 2.5 ms odbite światło płynie przez 375000 km. Układ ten miał doprecyzować z precyzją do poniżej 1 km wspomnianą odległość. 

# Układ pomiarowy
Schemat układu pomiarowego znajduje się poniżej.

<p align='center'>
<img src="https://github.com/mpdg837/Korelator-Cyfrowy/blob/main/Conclover.png"  width="800" height="400">
</p>

Port UART wychodzący z lasera ma prędkość zaledwie (a dla standardu UART aż) 100 kB/s (gdyż wykorzystano prędkość 1,22 Mbaud). Założono że pomiar 5 ms został zbuforowany i po odebraniu przesłany z mniejszą prędkością. Użyto tego standardu gdyż jest nadal powszechnie wspierany, łatwy w implementacji oraz laser ten można łatwo emulować za pomocą komputera z zainstalowanym pakietem Python wraz z biblioteką wspierającą port szeregowy.

Układ ten pozwala na szybkie liczenie odległości dzięki procesowi korelacji, która z mocno zaszumionego sygnału umożliwia wykrycie żądanego przebiegu. Aby przystosować ten system do możliwie najszybszych obliczeń na jakie pozwala technologia FPGA należało zaprojektować architekturę tego systemu.

# Architektura rozwiązania

Poniżej znajduje się schemat przedstawiający architekturę systemu SOC użytego do tego pomiaru:

<p align='center'>
<img src="https://github.com/mpdg837/Korelator-Cyfrowy/blob/main/ArchitectureConclover.png">
</p>

Do budowy tego systemu użyto poniższych komponentów
* Procesor 32-bitowy NIOS2/e
* Układ korelatora wykorzystujący DMA dzięki magistrali Avalon MM Master. Zasadę działania objaśniono w pliku pdf znajdującym się w tym repozytorium. Dzięki zwielokrotnieniu procesu odczytywania/zapisywania oraz samych obliczeń (korelacji czyli 20 mnożeń na wykonywanych fizycznie na raz oraz obliczania wartości bezwzględnej z wartości korelacji ograniczonej do 8 bitów z 24)
* Moduły I/O - moduł wyświetlacza 7-segmentowego z 4 cyframi oraz moduł przycisków
* Moduł nadawczo odbiorczy FastUART o niestandardowej prędkości 1,22 Mbaud/s (100 kB/s) umożliwiający pobieranie danych za pomocą portu RS232 będącego na płytce
* Moduły pomiaru czasu (4 x Timer o precyzji 1 us).

# Testy
 

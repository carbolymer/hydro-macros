hydro-macros
============

Macros for plotting results from relativistic hydrodynamics script.

1) drawDist.m - makro w Octave generujace rozklady dla serii symulacji o danym kroku czasowym i ustalonej siatce. Symulacje znajduja sie w katalogach o nazwie zgodnie ze schematem: hubble61t0.04. Pierwszy czlon nazwy to rodzaj warunkow poczatkowych, numer jest liczba porzadkowa, numerujaca wszystkie symulacje, zgodnie ze wzrostem rozmiaru siatki, a t0.04 to krok czasowy.
Wszystkie symulacje sa zdefiniowane w plikach konfiguracyjnych .xml (zawierajacych w nazwie typ przeplywu w symulacji).
Makro generuje rozkłady energii i prędkości po pierwszym i setnym kroku symulacji wraz z krzywa teoretyczna. Wykresy sa zapisywane w formacie .png w folderze ../images/ .
Format nazwy pliku: h62__e_x198dt0.006.png
h62 oznacza 62-ga symulacje przeplywu hubble'a o wymiarze siatki 198 i kroku czasowym dt=0.006fm.

2) drawTimes.m - makro rysujace czasy wykonywania wszystkich symulacji. Wynik jest zapisywany w pliku times.png

3) initialComparison.m - makro w Octave porownujace warunki poczatkowe z teoria



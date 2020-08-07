anioActual(2015).
%festival(nombre, lugar, bandas, precioBase).
%lugar(nombre, capacidad).
festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).

%banda(nombre, año, nacionalidad, popularidad).
banda(paulMasCarne,1960, uk, 70).
banda(muse,1994, uk, 45).
banda(kiss,1973, us, 63).
banda(erucaSativa,2007, ar, 60).
banda(judasPriest,1969, uk, 91).
banda(tanBionica,2012, ar, 71).
banda(miranda,2001, ar, 38).
banda(laRenga,1988, ar, 70).
banda(blackSabbath,1968, uk, 96).
banda(pharrellWilliams,2014, us, 85).


%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).
% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).

entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).
entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).
% … y asi para todas las filas
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).

% 1

estaDeModa(Banda):-
    banda(Banda, Anio, _, Popularidad),
    anioActual(AnioActual),
    Anio >= AnioActual - 5,
    Popularidad > 70 .

% 2

bandaDeFestival(Banda,Festival):-
    banda(Banda,_, _, _),
    festival(Festival, _, Bandas, _),
    member(Banda,Bandas).

esCareta(Festival):-
    bandaDeFestival(Banda1,Festival),
    bandaDeFestival(Banda2,Festival),
    Banda1 \= Banda2,
    estaDeModa(Banda1),
    estaDeModa(Banda2).
esCareta(Festival):-
    festival(Festival, _, _, _),
    bandaDeFestival(miranda,Festival).
esCareta(Festival):-
    festival(Festival, _, _, _),
    not(entradaRazonable(Festival,_)).

% 3

precio(Festival,campo,Precio):-
    festival(Festival, _, _, Precio).
precio(Festival,plateaNumerada(Fila),Precio):-
    festival(Festival, _, _, PrecioBase),
    Precio is PrecioBase + (200 / Fila).
precio(Festival,plateaGeneral(Zona),Precio):-
    festival(Festival, _, _, PrecioBase),
    plusZona(_, Zona, Plus),
    Precio is PrecioBase + Plus.

popularidadFestival(Festival,PopularidadTotal):-
 festival(Festival, _, _, _),
 findall(Popularidad,(banda(Banda,_,_,Popularidad),bandaDeFestival(Banda,Festival)),Popularidades),
 sum_list(Popularidades,PopularidadTotal).

festivalSinBandasDeModa(Festival):-
    festival(Festival, _, _, _),
    not((bandaDeFestival(Banda,Festival),estaDeModa(Banda))).

entradaRazonable(Festival,plateaGeneral(Zona)):-
    festival(Festival, lugar(Lugar, _), _, _),
    precio(Festival,plateaGeneral(Zona),Precio),
    plusZona(Lugar, Zona, Plus),
    Plus < (Precio * 10 / 100).   
entradaRazonable(Festival,campo):-
  precio(Festival,campo, Precio),
  popularidadFestival(Festival,Popularidad),
  Precio < Popularidad.
entradaRazonable(Festival,plateaNumerada(Fila)):-
    festivalSinBandasDeModa(Festival),
    precio(Festival,plateaNumerada(Fila),Precio),
    Precio =< 750.
entradaRazonable(Festival,plateaNumerada(Fila)):-
    precio(Festival,plateaNumerada(Fila),Precio),
    festival(Festival, lugar(_,Capacidad), _, _),
    popularidadFestival(Festival,Popularidad),
    Limite is Capacidad / Popularidad,
    Precio < Limite.
 
%  4
nacandpop(Festival):-
    festival(Festival, _, _, _),
    forall(bandaDeFestival(Banda,Festival),banda(Banda,_,ar,_)),
    entradaRazonable(Festival,_).

%  5
recaudacion(Festival,Total):-
  festival(Festival, _, _, _),
  findall(Recaudacion,
      (entradasVendidas(Festival, Entrada, Cantidad),precio(Festival,Entrada,Precio),
      Recaudacion is Precio * Cantidad),ListaRecaudacion),
  sum_list(ListaRecaudacion,Total).

%  6
estaBienPlaneado(Festival):-
    festival(Festival, _, Bandas, _),
    creceEnPopularidad(Bandas),
    last(Bandas,Banda),
    legendaria(Banda).

legendaria(Banda):-
    banda(Banda, Anio, Nacionalidad, Popularidad),
    Anio < 1980,
    Nacionalidad \= ar,
   forall((banda(Banda2,_,_,Popularidad2), estaDeModa(Banda2)) , Popularidad > Popularidad2).

creceEnPopularidad([Banda , Banda1 | Resto]):-
    banda(Banda,_,_,Popularidad),
    banda(Banda1,_,_,Popularidad1),
    Popularidad < Popularidad1,
   creceEnPopularidad([Banda1 | Resto]).
creceEnPopularidad([]).
creceEnPopularidad([_]).
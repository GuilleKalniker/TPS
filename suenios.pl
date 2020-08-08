% 1
creenEn(campanita,gabriel).
creenEn(magoDeOz,gabriel).
creenEn(cavenaghi,gabriel).
creenEn(conejoDePascua,juan).
creenEn(reyesMagos,macarena).
creenEn(magoCapria,macarena).
creenEn(campanita,macarena).

suenio(gabriel,ganarLoteria([5,9])).
suenio(gabriel,serFutbolista(arsenal)).
suenio(juan,serCantante(100000)).
suenio(macarena,serCantante(10000)).

persona(Persona):-
    creenEn(_,Persona).
personaje(Personaje):-
    creenEn(Personaje,_).

% 2
equipoChico(aldosivi).
equipoChico(arsenal).

dificultadSuenio(serCantante(Cantidad),6):-
    Cantidad >500000.
dificultadSuenio(serCantante(Cantidad),4):-
    Cantidad =< 500000.
dificultadSuenio(ganarLoteria(ListaNumeros),NroDificultad):-
    length(ListaNumeros,CantidadNumeros),
    NroDificultad is CantidadNumeros * 10.
dificultadSuenio(serFutbolista(Equipo),3):-
    equipoChico(Equipo).
dificultadSuenio(serFutbolista(Equipo),16):-
    not(equipoChico(Equipo)).

esAmbicioso(Persona):-
    persona(Persona),
    findall(Valor,(suenio(Persona,Suenio),dificultadSuenio(Suenio,Valor)),ValoresSuenio),
    sum_list(ValoresSuenio,Puntaje),
    Puntaje >20.

% 3

%hayQuimica(Personaje,Persona)
hayQuimica(campanita,Persona):-  
    creenEn(campanita,Persona),
    suenio(Persona,Suenio),
    dificultadSuenio(Suenio,Dif),
    Dif < 5.
hayQuimica(Personaje,Persona):-
    personaje(Personaje),
    Personaje \= campanita,
    persona(Persona),
    not(esAmbicioso(Persona)),
    forall(suenio(Persona,Suenio),suenioPuro(Suenio)).

suenioPuro(serFutbolista(_)).
suenioPuro(serCantante(Cantidad)):-
    Cantidad < 200000.

/* Me devuelve que Juan tiene quimica con mago de Oz y creo que tiene sentido pero no lo pone
dentro de las soluciones. Tambien me parece raro lo del findall porque no veo como lo podes
usar en este ej y tengo miedo de que en realidad sea un forall pero bueno, como no lo dice hago
como que no se confundio */

% 4


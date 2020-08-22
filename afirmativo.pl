 %tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tamaño, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

% Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

% Por último, se sabe quién es jefe de quién:
%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).


% 1

agente(Agente):-
    tarea(Agente,_,_).
buenosAires(avellaneda).
buenosAires(barracas).
buenosAires(laBoca).
buenosAires(marDelPlata).


frecuenta(Agente, Lugar):- 
    agente(Agente),
   tarea(Agente, _, Lugar).
frecuenta(Agente, Lugar):- 
    buenosAires(Lugar),
    agente(Agente).
frecuenta(vega, quilmes).
frecuenta(Agente, marDelPlata):- 
    agente(Agente),
    tarea(Agente, vigilar(Lugares),_),
    member(tiendaDeAlfajores,Lugares).


% 2

inaccesible(Lugar):-
    ubicacion(Lugar),
    not(frecuenta(_,Lugar)).


% 3

afincado(Agente):-
tarea(Agente, _,Ubicacion),
not((tarea(Agente,_,Ubicacion2), Ubicacion \= Ubicacion2)).

% 4

cadenaDeMando([Jefe,Jefe1 | MasJefes]):-
    jefe(Jefe,Jefe1 ),
    cadenaDeMando([Jefe1 | MasJefes]).
cadenaDeMando([]).
cadenaDeMando([_]).

% 5

puntajeTarea(vigilar(Negocios),Puntaje):-
    length(Negocios,CantidadNegocios),
    Puntaje is 5 * CantidadNegocios.
puntajeTarea(ingerir(_, Tamanio, Cantidad),Puntaje):-
    Unidades is Tamanio * Cantidad,
    Puntaje is Unidades * -10.
puntajeTarea(apresar(_,Recompensa),Puntaje):-
    Puntaje is Recompensa / 2.
puntajeTarea(asuntosInternos(Agente),Puntaje):-
    puntuacion(Agente,Puntuacion),
    Puntaje is Puntuacion * 2.

puntuacion(Agente,Puntaje):-
    agente(Agente),
    findall(P,(tarea(Agente,Tarea,_),puntajeTarea(Tarea,P)),Puntos),
    sum_list(Puntos,Puntaje).

agentePremiado(Agente):-
    puntuacion(Agente,Puntaje),
forall((puntuacion(OtroAgente,Puntaje2), OtroAgente\=Agente),
               Puntaje > Puntaje2).



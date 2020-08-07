personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).


%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

% 1

esPeligroso(Personaje):-
    personaje(Personaje, mafioso(maton)).
esPeligroso(Personaje):-
    personaje(Personaje, ladron(Asaltos)),
    member(licorerias,Asaltos).
esPeligroso(Personaje):-
  trabajaPara(Personaje, Empleado),
  esPeligroso(Empleado).

% 2
duo(Personaje,OtroPersonaje):-
    pareja(Personaje, OtroPersonaje).
duo(Personaje,OtroPersonaje):-
    amigo(Personaje, OtroPersonaje).

duoTemible(Personaje,OtroPersonaje):-
 esPeligroso(Personaje),
 esPeligroso(OtroPersonaje),
 Personaje \= OtroPersonaje,
 duo(Personaje,OtroPersonaje).

% 3
personajeConJefePeligroso(Personaje,Jefe):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe).

estaEnProblemas(Personaje):-
 personajeConJefePeligroso(Personaje,Jefe),
 encargo(Jefe,Personaje,cuidar(Protegido)),
 pareja(Jefe,Protegido).
estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(OtroPersonaje, _)),
    personaje(OtroPersonaje,boxeador).

% 4

tieneCerca(Personaje,OtroPersonaje):-
    amigo(Personaje, OtroPersonaje).
tieneCerca(Personaje,OtroPersonaje):-
    trabajaPara(Personaje, OtroPersonaje).

sanCayetano(Personaje):-
 personaje(Personaje, _),
 tieneCerca(Personaje,_),
 forall(tieneCerca(Personaje,OtroPersonaje),encargo(Personaje,OtroPersonaje,_)).
                

% 5
cantidadTareas(Personaje,Total):-
    personaje(Personaje, _),
    findall(Tarea,encargo(_, Personaje,Tarea),Tareas),
    length(Tareas,Total).

masAtareado(Personaje):-
    cantidadTareas(Personaje,Total),
    forall((cantidadTareas(OtroPersonaje,Total2),OtroPersonaje \= Personaje), Total2 =< Total).

% 6

respeto(actriz(Peliculas),Respeto):-
    length(Peliculas,Cantidad),
    Respeto is Cantidad // 10.
respeto(mafioso(resuelveProblemas),10).
respeto(mafioso(maton),1).
respeto(mafioso(capo),20).

personajeRespetable(Personaje):-
    personaje(Personaje, Tarea),
    respeto(Tarea,PuntosDeRespeto),
    PuntosDeRespeto > 9.

personajesRespetables(ListaRespetados):-
    findall(Respetado,personajeRespetable(Respetado),ListaRespetados).

% 7
interactuan(Personaje,cuidar(Personaje)).
interactuan(Personaje,ayudar(Personaje)).
interactuan(Personaje,buscar(Personaje,_)).  
interactuan(Personaje,cuidar(Amigo)):-
    amigo(Personaje,Amigo).
interactuan(Personaje,ayudar(Amigo)):-
    amigo(Personaje,Amigo).
interactuan(Personaje,buscar(Amigo,_)):-
    amigo(Personaje,Amigo).

hartoDe(Personaje,OtroPersonaje):-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    Personaje \= OtroPersonaje,
    encargo(_,Personaje,_),
    forall(encargo(_,Personaje,Tarea),interactuan(OtroPersonaje,Tarea)).

% 8
caracteristicas(vincent,[negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,  [tieneCabeza, muchoPelo]).
caracteristicas(marvin, [negro]).

caracteristicaDiferente(Lista1,Lista2):-
    member(Lista1,Caracteristica),
    not(member(Caracteristica,Lista2)).

duoDiferenciable(Personaje,OtroPersonaje):-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    duo(Personaje,OtroPersonaje),
    caracteristicas(Personaje,Lista1),
    caracteristicas(OtroPersonaje,Lista2),
    caracteristicaDiferente(Lista1,Lista2).

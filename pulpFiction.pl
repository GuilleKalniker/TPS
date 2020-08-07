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
duoPeligroso(Personaje,OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    Personaje \= OtroPersonaje.

duoTemible(Personaje,OtroPersonaje):-
 duoPeligroso(Personaje,OtroPersonaje),
 amigo(Personaje, OtroPersonaje).
duoTemible(Personaje,OtroPersonaje):-
    duoPeligroso(Personaje,OtroPersonaje),
    pareja(Personaje, OtroPersonaje).

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
 forall(tieneCerca(Personaje,OtroPersonaje),encargo(Personaje,OtroPersonaje,_)).
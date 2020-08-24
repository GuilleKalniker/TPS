herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).


%1
%tiene(persona,objeto).

tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(peter,trapeador).
tiene(winston,varitaDeNeutrones).

%2
% satisfaceNecesidad(Persona,Herramienta).

satisfaceNecesidad(Persona,Herramienta):-
    tiene(Persona,Herramienta),
    Herramienta \= aspiradora(_),
    herramientaRequerida(Herramienta,_).
satisfaceNecesidad(Persona,aspiradora(Potencia)):-
    tiene(Persona,aspiradora(Potencia)),
    herramientaRequerida(aspiradora(OtraPotencia),_),
    Potencia >= OtraPotencia.

herramientaRequerida(Herramienta,Tarea):-
    herramientasRequeridas(Tarea, Herramientas),
    member(Herramienta,Herramientas).

%3
tarea(Tarea):-
    herramientasRequeridas(Tarea, _).

puedeRealizar(Persona,Tarea):-
    tiene(Persona,varitaDeNeutrones),
    tarea(Tarea).
puedeRealizar(Persona,Tarea):-
    tiene(Persona,_),
    tarea(Tarea),
    forall(herramientaRequerida(Herramienta,Tarea), tiene(Persona,Herramienta)).

% 4

tareaPedida(cliente,tarea,metros).
precio(tarea,precioPorMetro).

costoPedidos(Cliente,CostoTotal):-
    tareaPedida(Cliente,_,_),
    findall(Costo,(tareaPedida(Cliente,Tarea,Metros),precio(Tarea,PrecioPorMetro),Costo is Metros * PrecioPorMetro),Costos),
    sum_list(Costo,CostoTotal).

% 5

aceptaPedido(Persona,Pedido):-
    acepta(Persona,Pedido),
    forall(member(Tarea,Pedido),puedeRealizar(Persona,Tarea)).


acepta(ray,Pedido):-
     not(member(limpiarTecho,Pedido)).
acepta(egon,Pedido):-
    not((member(Tarea,Pedido),tareaCompleja(Tarea))).
acepta(peter,Pedido):-
    forall(member(Tarea,Pedido),tarea(Tarea)).

tareaCompleja(limpiarTecho).
tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas,Cantidad),
    Cantidad > 2.

% 6


herramientasRequeridas2(limpiarBanio, [sopapa, trapeador]).
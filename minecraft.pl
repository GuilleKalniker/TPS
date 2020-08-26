
%jugador(nombre,items,hambre).
jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

%lugar(lugar,jugadoresEnEseLugar,oscuridad).
lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).
 
%1

%A. Relacionar un jugador con un ítem que posee.

tieneItem(Jugador,Item):-
    jugador(Jugador,Items,_),
    member(Item,Items).


%B. Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible. 

sePreocupaPorSuSalud(Jugador):-
    tieneItem(Jugador,Item),
    comestible(Item).

%C. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad que tiene de ese ítem. 
%Si no posee el ítem, la cantidad es 0. cantidadDeItem/3
item(Item):-
tieneItem(_,Item).

cantidadDeItem(Jugador,Item,Cantidad):-
    jugador(Jugador,Items,_),
    item(Item),
    findall(Item,member(Item,Items),CantidadItem),
    length(CantidadItem,Cantidad).
    
%D. Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad tiene de ese ítem. tieneMasDe/2

tieneMasDe(Jugador,Item):-
    cantidadDeItem(Jugador,Item,Cantidad),
    forall((cantidadDeItem(Jugador2,Item,Cantidad2),Jugador2 \= Jugador), Cantidad > Cantidad2).


%2
%A. Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen 
%en los lugares cuyo nivel de oscuridad es más de 6. hayMonstruos/1

hayMonstruos(Lugar):-
    lugar(Lugar,_,Oscuridad),
    Oscuridad > 6.

%B. Saber si un jugador corre peligro. Un jugador corre peligro si se encuentra en un 
%lugar donde hay monstruos; o si está hambriento (hambre < 4) y no cuenta con ítems comestibles. correPeligro/1

correPeligro(Jugador):-
    jugador(Jugador,_,_),
    lugar(Lugar,Jugadores,_),
    member(Jugador,Jugadores),
    hayMonstruos(Lugar).

correPeligro(Jugador):-
    hambriento(Jugador),
    not(sePreocupaPorSuSalud(Jugador)).

hambriento(Jugador):-
    jugador(Jugador,_,NivelHambre),
    NivelHambre < 4.

%C. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
%- Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
%- Si hay monstruos, es 100.
%- Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. nivelPeligrosidad/2

%?- nivelPeligrosidad(playa,Peligrosidad).
%Peligrosidad = 50.

nivelPeligrosidad(Lugar,Peligrosidad):-
    lugar(Lugar,Jugadores,_),
    not(hayMonstruos(Lugar)),
    cantidadHabitantes(Lugar,CantidadTotal),
    findall(J,(member(J,Jugadores),hambriento(J)),Hambrientos),
    length(Hambrientos,CantidadHambrientos),
    Peligrosidad is (CantidadHambrientos*100) / CantidadTotal.
nivelPeligrosidad(Lugar,100):-
    hayMonstruos(Lugar).
nivelPeligrosidad(Lugar,Peligrosidad):-
    lugar(Lugar,_,Oscuridad),
    cantidadHabitantes(Lugar,0),
    Peligrosidad is Oscuridad *10.


cantidadHabitantes(Lugar,Cantidad):-
    lugar(Lugar,Jugadores,_),
    length(Jugadores,Cantidad).


/* El aspecto más popular del juego es la construcción. Se pueden construir nuevos ítems a partir de otros, 
cada uno tiene ciertos requisitos para poder construirse:
- Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. 
Por ejemplo, 8 unidades de piedra.
- Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2

?- puedeConstruir(stuart, horno).
true.
?- puedeConstruir(steve, antorcha).
true.

Aclaración: Considerar a los componentes de los ítems compuestos y a los ítems simples como excluyentes, 
es decir no puede haber más de un ítem que requiera el mismo elemento. */ 

item(horno, [itemSimple(piedra, 8)]).
item(placaDeMadera, [itemSimple(madera, 1)]).
item(palo, [ itemCompuesto(placaDeMadera)]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1)]).

materiaPrimaPara(Objeto,Materiales):-
    item(Objeto, Materiales),
    member(ItemComuesto,Materiales),
    item(ItemComuesto)


%4
/* 
A) Daria false dado que el desierto no es un lugar de nuestra base de conociemintos , por el principio de universo cerrado,
que plantea que todo lo que no esta definido es falso.
B)
*/





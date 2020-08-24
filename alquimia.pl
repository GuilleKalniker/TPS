herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

%tiene(Persona,Recurso).
tiene(ana,vapor).
tiene(ana,agua).
tiene(ana,tierra).
tiene(ana,hierro).
tiene(beto,vapor).
tiene(beto,agua).
tiene(beto,tierra).
tiene(beto,hierro).
tiene(cata,fuego).
tiene(cata,tierra).
tiene(cata,agua).
tiene(cata,aire).

%elementosParaConstruir(Elemento, [Recurso1,Recurso2,...,etc]).
elementosParaConstruir(pasto, [agua,tierra]).
elementosParaConstruir(hierro, [agua,tierra,fuego]).
elementosParaConstruir(huesos, [agua,pasto]).
elementosParaConstruir(presion, [hierro,vapor]).
elementosParaConstruir(vapor, [fuego,agua]).
elementosParaConstruir(playStation, [silicio,hierro,plastico]).
elementosParaConstruir(silicio, [tierra]).
elementosParaConstruir(plastico, [huesos,presion]).

%1

jugador(Persona):-
    tiene(Persona,_).

elemento(Elemento):-
    elementosParaConstruir(Elemento, _).
elemento(Elemento):-
    elementosParaConstruir(_, Elementos),
    member(Elemento,Elementos).

%2
tieneIngredientesPara(Elemento,Jugador):-
    tiene(Jugador,_),
    elementosParaConstruir(Elemento,_),
    forall(elementoRequeridoPara(ElementoNecesario,Elemento), tiene(Jugador,ElementoNecesario)).

elementoRequeridoPara(ElementoNecesario,Elemento):-
    elementosParaConstruir(Elemento, ElementosNecesarios),
    member(ElementoNecesario,ElementosNecesarios).

%3

elementoVivo(fuego).
elementoVivo(agua).
elementoVivo(Elemento):-
    elementoRequeridoPara(UnElemento,Elemento),
    elementoVivo(UnElemento).



%4

puedeConstruir(Persona,Elemento):-
  tieneIngredientesPara(Elemento,Persona),
  herramientaRequerida(Elemento,Herramienta),
  herramienta(Persona,Herramienta).


herramientaRequerida(Elemento,libro(vida)):-
    elementoVivo(Elemento).
herramientaRequerida(Elemento,libro(inerte)):-
    not(elementoVivo(Elemento)).
herramientaRequerida(Elemento,cuchara(Centimetros)):-
    soporta(cuchara(Centimetros),Soporta),
    cantidadElementos(Elemento,Cantidad),
    Soporta > Cantidad.
herramientaRequerida(Elemento,circulo(Diametro,Niveles)):-
    soporta(circulo(Diametro,Niveles),Soporta),
    cantidadElementos(Elemento,Cantidad),
    Soporta > Cantidad.

cantidadElementos(Elemento,Cantidad):-
    elementosParaConstruir(Elemento,Elementos),
    length(Elementos,Cantidad).

soporta(cuchara(Centimetros),Cantidad):-
    herramienta(_, cuchara(Centimetros)),
    Cantidad is Centimetros / 10.
soporta(circulo(Diametro,Niveles),Cantidad):-
    herramienta(_, circulo(Diametro,Niveles)),
    Cantidad is (Diametro /100) * Niveles.

%5

todoPoderoso(Persona):-
    jugador(Persona),
    forall(elementoPrimitivo(Elemento),tiene(Persona,Elemento)),
    forall( (not(tiene(Persona,Elemento)),herramientaRequerida(Elemento,Herramienta)), herramienta(Persona,Herramienta)).    


elementoPrimitivo(Elemento):-
     elemento(Elemento),
    not(elementosParaConstruir(Elemento, _)).

%6

quienGana(Jugador):-
    cantidadConstrucciones(Jugador,Cantidad),
    forall((cantidadConstrucciones(OtroJugador,Cantidad2), OtroJugador \= Jugador), Cantidad > Cantidad2).

cantidadConstrucciones(Jugador,Cantidad):-
    jugador(Jugador),
    findall(C,distinct(C, puedeConstruir(Jugador,C)), Construcciones),
    length(Construcciones,Cantidad).

%7

/*  
Un ejemplo de universo cerrado se puede ver al modelar el elemento que tiene cada jugador. El texto indicaba, por ejemplo, 
que Cata tiene fuego, tierra, agua y aire, pero no tiene vapor. Y al modelar los elementos de Cata solo se dice lo que tiene, es decir, fuego, tierra,agua y aire, 
dado que se entiende por universo cerrado que todo lo que no se diga que tenga va a ser falso. Por lo tanto, si se consulta por consola si es verdad que Cata
no tiene vapor el resultado sera verdadero.
 */

%8


 % Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).
tripulante(law, heart).
tripulante(bepo, heart).
tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy,baroqueWorks, 70000000).
impactoEnRecompensa(luffy,eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy,dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo,240000000).
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo,sabaody,500).
impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

%1
%eventoCompartido(Tripulacion,OtraTripulacion,Evento).
eventoCompartido(Tripulacion,OtraTripulacion,Evento):-
    participoEvento(Tripulacion,Evento),
    participoEvento(OtraTripulacion,Evento),
     Tripulacion \= OtraTripulacion.

participoEvento(Tripulacion,Evento):-
 impactoEnRecompensa(Pirata, Evento, _),
 tripulante(Pirata,Tripulacion).

%2
% pirataDestacado(Pirata,Evento).

pirataDestacado(Pirata,Evento):-
 impactoEnRecompensa(Pirata, Evento, Impacto),
 forall((impactoEnRecompensa(OtroPirata, Evento, OtroImpacto), 
 OtroPirata \=Pirata), Impacto > OtroImpacto).


%3
desapercibido(Tripulante,Evento):-
 tripulante(Tripulante,Tripulacion),
 tripulante(OtroTripulante,Tripulacion),
 impactoEnRecompensa(OtroTripulante,Evento, _),
 not(impactoEnRecompensa(Tripulante,Evento,_)).


%4
recompensaTotal(Tripulacion,RecompensaTotal):-
tripulante(_,Tripulacion),
findall(Recompensa,(tripulante(Pirata,Tripulacion),impactoEnRecompensa(Pirata, _, Recompensa)),Recompensas),
sum_list(Recompensas,RecompensaTotal).

%5

tripulacionTemible(Tripulacion):-
recompensaTotal(Tripulacion,RecompensaTotal),
RecompensaTotal > 500000000.
tripulacionTemible(Tripulacion):-
tripulante(_,Tripulacion),
forall(tripulante(Tripulante,Tripulacion), esPeligroso(Tripulante)).

esPeligroso(Tripulante):-
impactoEnRecompensa(Tripulante, _, Recompensa),
Recompensa > 100000000.

%6
esPeligroso2(Tripulante):-
 comio(Tripulante, Fruta),
 frutaPeligrosa(Fruta).

comio(luffy, fruta(gomugomu,paramecia(segura))).
comio(buggy , fruta(barabara ,paramecia(segura))).
comio(law , fruta(opeope ,paramecia(peligrosa))).
comio(chopper , fruta(hitohito ,zoan(humano))).
comio(lucci , fruta(nekoneko ,zoan(leopardo))).
comio(smoker  , fruta(mokumoku  ,logia(humo))).

frutaPeligrosa(fruta(_ ,paramecia(peligrosa))).
frutaPeligrosa(fruta(_ ,zoan(lobo))).
frutaPeligrosa(fruta(_ ,zoan(leopardo))).
frutaPeligrosa(fruta(_ ,zoan(anaconda))).
frutaPeligrosa(fruta(_ ,logia(_))).


%7 

noNada(Pirata):-
tripulante(Pirata,_),
comio(Pirata,_).

tripulacionDeAsfalto(Tripulacion):-
tripulante(_,Tripulacion),
forall(tripulante(Pirata,Tripulacion), noNada(Pirata)).

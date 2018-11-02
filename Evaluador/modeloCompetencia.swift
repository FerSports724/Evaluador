//
//  modeloCompetencia.swift
//  Evaluador
//
//  Created by FERNANDO on 17/09/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import Foundation

class modeloCompetencia{
    var nivel3:String!
    var nivel2:String!
    var nivel1:String!
    var nivel0:String!
    var noAplica:String!
    
    init(nivel3:String, nivel2:String, nivel1:String, nivel0:String, noAplica:String){
        self.nivel3 = nivel3
        self.nivel2 = nivel2
        self.nivel1 = nivel1
        self.nivel0 = nivel0
        self.noAplica = noAplica
    }
}

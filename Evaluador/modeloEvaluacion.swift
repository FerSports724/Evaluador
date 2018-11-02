//
//  modeloEvaluacion.swift
//  Evaluador
//
//  Created by FERNANDO on 28/08/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import Foundation

class modeloEvaluacion{
    
    var id:Int!
    var profesor:String!
    var materia:String!
    var semestre:Int!
    var periodo:Int!
    var fecha:String!
    var competencia3_1:Int!
    var competencia3_3:Int!
    var competencia4_1:Int!
    var competencia4_1_1:Int!
    var competencia4_2:Int!
    var competencia4_5:Int!
    var competencia6_2:Int!
    var competencia6_3:Int!
    var competencia6_4:Int!
    var competencia7_5:Int!
    var puntaje:Int!
    var observaciones:String!
    
    init(id:Int, profesor:String, materia:String, semestre:Int, periodo:Int, fecha:String, competencia3_1:Int, competencia3_3:Int, competencia4_1:Int, competencia4_1_1:Int, competencia4_2:Int, competencia4_5:Int, competencia6_2:Int, competencia6_3:Int, competencia6_4:Int, competencia7_5:Int, puntaje:Int, observaciones:String){
        
        self.id = id
        self.profesor = profesor
        self.materia = materia
        self.semestre = semestre
        self.periodo = periodo
        self.fecha = fecha
        self.competencia3_1 = competencia3_1
        self.competencia3_3 = competencia3_3
        self.competencia4_1 = competencia4_1
        self.competencia4_1_1 = competencia4_1_1
        self.competencia4_2 = competencia4_2
        self.competencia4_5 = competencia4_5
        self.competencia6_2 = competencia6_2
        self.competencia6_3 = competencia6_3
        self.competencia6_4 = competencia6_4
        self.competencia7_5 = competencia7_5
        self.puntaje = puntaje
        self.observaciones = observaciones
        
    }
    
}

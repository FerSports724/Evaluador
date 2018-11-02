//
//  modeloMaestro.swift
//  Evaluador
//
//  Created by FERNANDO on 27/08/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import Foundation

class modeloMaestro{
    
    var id:String!
    var nombre:String!
    var selector:String!
    var imagen:String!
    
    init(id:String, nombre:String, selector:String, imagen:String){
        self.id = id
        self.nombre = nombre
        self.selector = selector
        self.imagen = imagen
    }
    
}

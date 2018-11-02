//
//  confirmarRegistroVC.swift
//  Evaluador
//
//  Created by FERNANDO on 18/09/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class confirmarRegistroVC: UIViewController {
    
    var idDelRegistro = Int()
    var cantidadNoAplica:Int = 0
    var puntajeTotal:Int!
    var arrayDeResultados:[Int] = []
    let arrayComlumnas:[String] = ["competencia3_1", "competencia3_3", "competencia4_1", "competencia4_1_1", "competencia4_2", "competencia4_5", "competencia6_2", "competencia6_3", "competencia6_4", "competencia7_5"]
    
    var huboNA:Bool = false
    var seleccionMaestro:[modeloEvaluacion] = []
    
    @IBOutlet var labelNombre: UILabel!
    @IBOutlet var labelMateria: UILabel!
    @IBOutlet var labelPuntaje: UILabel!
    @IBOutlet var labelNoAplica: UILabel!
    @IBOutlet var labelCompetenciaResultados: UILabel!
    
    @IBOutlet var textViewObs: UITextView!
    
    let objetoFileHelper = FileHelper()
    var miBaseDatos:FMDatabase? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewObs.delegate = self
        
        huboNA = false
        cantidadNoAplica = 0
        puntajeTotal = 0
        
        miBaseDatos = FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: "Evaluacion"))
        colocarDatos(id: idDelRegistro)
        noAplica(id: idDelRegistro)
        docenteConCompetencias(id: idDelRegistro, puntaje: puntajeTotal, noAplica: cantidadNoAplica)
        print("El id que llegó es: \(idDelRegistro)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func botonConfirmar(_ sender: UIButton) {
        /*Actualizar las observaciones*/
        if textViewObs.text != ""{
            actulizarObservaciones(observacionMaestro: textViewObs.text, idMaestro: idDelRegistro)
        }
        
        let alert = UIAlertController(title: "Registro Guardado", message: "Se ha guardado correctamente un registro para \(labelNombre.text!)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    /*Colocar los datos*/
    func colocarDatos(id:Int){
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let queryParaTodo = "SELECT * FROM evaluaciones WHERE id='\(id)'"
            let resultadosTodos:FMResultSet? = miBaseDatos!.executeQuery(queryParaTodo, withArgumentsIn: [])
            while resultadosTodos!.next() == true{
                labelNombre.text = resultadosTodos!.string(forColumn: "profesor")
                labelMateria.text = resultadosTodos!.string(forColumn: "materia")
                textViewObs.text = resultadosTodos!.string(forColumn: "observaciones")
                //labelPuntaje.text = String(Int(resultadosTodos!.int(forColumn: "puntaje")))
            }
            /*Cerrar base de datos*/
            miBaseDatos?.close()
        }else{
            print("Error al abrir base de datos.")
        }
    }
    
    /*Función para actualizar las observaciones*/
    func actulizarObservaciones(observacionMaestro:String, idMaestro:Int){
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let actualizarDatos = "UPDATE evaluaciones SET observaciones = '"+observacionMaestro+"' WHERE id='\(idMaestro)'"
            let resultadosActualizar = miBaseDatos!.executeUpdate(actualizarDatos, withArgumentsIn: [])
            
            if resultadosActualizar{
                print("Se ha actulizado un registro")
            }else{
                print("Error en base de datos: \(miBaseDatos!.lastErrorMessage())")
            }
            /*Cerrar base de datos*/
            miBaseDatos?.close()
        }else{
            print("Error al abrir base de datos.")
        }
    }
    
    /*Función para saber cuántos N/A hubo y modificar el puntaje total*/
    func noAplica(id:Int){
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let queryParaTodo = "SELECT competencia3_1, competencia3_3, competencia4_1, competencia4_1_1, competencia4_2, competencia4_5, competencia6_2, competencia6_3, competencia6_4, competencia7_5, puntaje FROM evaluaciones WHERE id='\(id)'"
            let resultadosTodos:FMResultSet? = miBaseDatos!.executeQuery(queryParaTodo, withArgumentsIn: [])
            while resultadosTodos!.next() == true{
                puntajeTotal = Int(resultadosTodos!.int(forColumn: "puntaje"))
                for index in 0...(arrayComlumnas.count-1){
                    arrayDeResultados.append(Int(resultadosTodos!.int(forColumn: "\(arrayComlumnas[index])")))
                    if (arrayDeResultados[index]<0){
                        cantidadNoAplica+=1
                    }
                    print("\(arrayDeResultados[index])")
                }
            }
            
            if cantidadNoAplica>=1{
                huboNA = true
                labelNoAplica.text = String(cantidadNoAplica)
                puntajeTotal = puntajeTotal + (cantidadNoAplica*3)
                labelPuntaje.text = String(puntajeTotal)
                
                /*Actualizar Base De Datos*/
                let actualizarPuntaje = "UPDATE evaluaciones SET puntaje = '\(puntajeTotal!)' WHERE id='\(id)'"
                let resultadosActualizar = miBaseDatos!.executeUpdate(actualizarPuntaje, withArgumentsIn: [])
                
                if resultadosActualizar{
                    print("Se ha actulizado un registro")
                }else{
                    print("Error en base de datos: \(miBaseDatos!.lastErrorMessage())")
                }
                
            }else{
                huboNA = false
                labelNoAplica.text = "0"
                labelPuntaje.text = String(puntajeTotal)
            }
            
            
            /*Cerrar base de datos*/
            miBaseDatos?.close()
        }else{
            print("Error al abrir base de datos.")
        }
    }
    
    /*Verificar si es docente con competencias*/
    func docenteConCompetencias(id:Int, puntaje:Int, noAplica:Int){
        switch noAplica{
        case 0:
            if (puntaje>=20 && puntaje<=30){
                labelCompetenciaResultados.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelCompetenciaResultados.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        case 1:
            if (puntaje>=17 && puntaje<=27){
                labelCompetenciaResultados.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelCompetenciaResultados.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        case 2:
            if (puntaje>=14 && puntaje<=24){
                labelCompetenciaResultados.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelCompetenciaResultados.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        case 3:
            if (puntaje>=11 && puntaje<=21){
                labelCompetenciaResultados.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelCompetenciaResultados.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        default:
            print("Quero mi lechita.")
        }
    }
}

/*Delegado para esconder el teclado con intro*/
extension confirmarRegistroVC: UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

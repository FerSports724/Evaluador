//
//  editarVC.swift
//  Evaluador
//
//  Created by FERNANDO on 12/10/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class editarVC: UIViewController {
    
    var idEntrante:Int = Int()
    var maestra:String = String()
    
    let objetoFileHelper = FileHelper()
    var miBaseDatos:FMDatabase? = nil
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miBaseDatos = FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: "Evaluacion"))
        
        colocarDatos(id: idEntrante)
        
        print("El id es: \(idEntrante)")
    }
    
    @IBAction func guardarObservaciones(_ sender: UIButton) {
        if textView.text != ""{
            actulizarObservaciones(observaciones: textView.text, id: idEntrante)
        }
        
        let alert = UIAlertController(title: "Registro Actualizado", message: "Las observaciones se han actualizado correctamente.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    
    /*Colocar las observaciones*/
    func colocarDatos(id:Int){
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let queryParaTodo = "SELECT * FROM evaluaciones WHERE id='\(id)'"
            let resultadosTodos:FMResultSet? = miBaseDatos!.executeQuery(queryParaTodo, withArgumentsIn: [])
            while resultadosTodos!.next() == true{
                textView.text = resultadosTodos!.string(forColumn: "observaciones")
            }
            /*Cerrar base de datos*/
            miBaseDatos?.close()
        }else{
            print("Error al abrir base de datos.")
        }
    }
    
    /*Función para actualizar las observaciones*/
    func actulizarObservaciones(observaciones:String, id:Int){
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let actualizarDatos = "UPDATE evaluaciones SET observaciones = '"+observaciones+"' WHERE id='\(id)'"
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
    
}

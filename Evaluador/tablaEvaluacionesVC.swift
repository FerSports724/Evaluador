//
//  tablaEvaluacionesVC.swift
//  Evaluador
//
//  Created by FERNANDO on 27/08/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class tablaEvaluacionesVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    var hayResultados:Bool = false
    var maestroSeleccionado = String()
    var selectorMaestro = String()
    var materiasTabla:[modeloEvaluacion] = []
    
    let objetoFileHelper = FileHelper()
    var miBaseDatos:FMDatabase? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        print("\(maestroSeleccionado)")
        miBaseDatos = FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: "Evaluacion"))
        
        mostrarResultadosConsulta(profesor: "\(maestroSeleccionado)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mostrarResultadosConsulta(profesor:String){
        
        /*Abrir la base de datos*/
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let queryParaTodo = "SELECT * FROM evaluaciones WHERE profesor = '"+profesor+"'"
            let resultadosTodos:FMResultSet? = miBaseDatos!.executeQuery(queryParaTodo, withArgumentsIn: [])
            
            while resultadosTodos!.next() == true{
                let materiasDelMaestro = modeloEvaluacion(id: Int(resultadosTodos!.int(forColumn: "id")), profesor: resultadosTodos!.string(forColumn: "profesor")!, materia: resultadosTodos!.string(forColumn: "materia")!, semestre: Int(resultadosTodos!.int(forColumn: "semestre")), periodo: Int(resultadosTodos!.int(forColumn: "periodo")), fecha: resultadosTodos!.string(forColumn: "fecha")!, competencia3_1: Int(resultadosTodos!.int(forColumn: "competencia3_1")), competencia3_3: Int(resultadosTodos!.int(forColumn: "competencia3_3")), competencia4_1: Int(resultadosTodos!.int(forColumn: "competencia4_1")), competencia4_1_1: Int(resultadosTodos!.int(forColumn: "competencia4_1_1")), competencia4_2: Int(resultadosTodos!.int(forColumn: "competencia4_2")), competencia4_5: Int(resultadosTodos!.int(forColumn: "competencia4_5")), competencia6_2: Int(resultadosTodos!.int(forColumn: "competencia6_2")), competencia6_3: Int(resultadosTodos!.int(forColumn: "competencia6_3")), competencia6_4: Int(resultadosTodos!.int(forColumn: "competencia6_4")), competencia7_5: Int(resultadosTodos!.int(forColumn: "competencia7_5")), puntaje: Int(resultadosTodos!.int(forColumn: "puntaje")), observaciones: resultadosTodos!.string(forColumn: "observaciones")!)
                materiasTabla.append(materiasDelMaestro)
            }
            
            /*Aquí verifico si hay resultados con la consulta realizada.*/
            if (materiasTabla.count) > 0{
                hayResultados = true
            }else{
                hayResultados = false
            }
            
            /*Cerrar base de datos*/
            miBaseDatos?.close()
            
        }else{
            print("Error al abrir base de datos.")
        }
        
    }
    
    /*Botón nueva evaluacion*/
    @IBAction func anadirEvaluacion(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "nuevaEvaluacion") as! nuevaEvaluacionVC
        navigationController?.pushViewController(vc, animated: true)
        vc.maestroSeleccionado = maestroSeleccionado
    }
    
    /*Eliminar datos de base de datos*/
    func eliminarDatos(id:Int){
        /*Abrir la base de datos*/
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let queryBorrar = "DELETE FROM evaluaciones WHERE id = '\(id)'"
            let resultadosBorrar = miBaseDatos!.executeUpdate(queryBorrar, withArgumentsIn: [])
            
            if resultadosBorrar{
                print("Se ha borrado un registro")
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

extension tablaEvaluacionesVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        eliminarDatos(id: materiasTabla[indexPath.row].id)
        
        if editingStyle == .delete{
            materiasTabla.remove(at: indexPath.row)
        }
        
        tableView.reloadData()
    }
    
}

extension tablaEvaluacionesVC:UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hayResultados{
            return materiasTabla.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if hayResultados{
            let materia = materiasTabla[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaRegistros") as! celdaRegistroMateria
            celda.labelMateria.text = materia.materia
            celda.labelFecha.text = materia.fecha
            celda.accessoryType = .disclosureIndicator
            return celda
        }else{
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaRegistros") as! celdaRegistroMateria
            celda.labelMateria.text = "No existen registros para \(maestroSeleccionado)"
            celda.labelMateria.textAlignment = .center
            celda.labelFecha.text = ""
            tableView.isUserInteractionEnabled = false
            return celda
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrayPasar:[Any] = []
        arrayPasar = [materiasTabla[indexPath.row].id, materiasTabla[indexPath.row].materia]
        self.performSegue(withIdentifier: "segueDetalles", sender: arrayPasar)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let seleccion = sender as! [Any]
        let pantallaDetalles:detallesVC = segue.destination as! detallesVC
        pantallaDetalles.materia = seleccion.last as! String
        pantallaDetalles.idMateria = seleccion.first as! Int
    }
}

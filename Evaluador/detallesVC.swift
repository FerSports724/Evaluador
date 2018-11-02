//
//  detallesVC.swift
//  Evaluador
//
//  Created by FERNANDO on 29/08/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class detallesVC: UIViewController {
    
    @IBOutlet var labelNombreProfesor: UILabel!
    @IBOutlet var labelMateria: UILabel!
    @IBOutlet var labelSemestre: UILabel!
    @IBOutlet var labelPeriodo: UILabel!
    @IBOutlet var labelFecha: UILabel!
    @IBOutlet var labelPuntaje: UILabel!
    @IBOutlet var labelNoAplica: UILabel!
    @IBOutlet var labelResultado: UILabel!
    @IBOutlet var labelObservaciones: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var arrayTituloCompetencias:[String] = ["3.1 Identifica los conocimientos previos y necesidades de formación de los estudiantes, y desarrolla estrategias para avanzar a partir de ellas.", "3.3 Diseña y utiliza en el salón de clases materiales apropiados para el desarrollo de competencias.", "4.1 Comunica ideas y conceptos con claridad en los diferentes ambientes de aprendizaje y ofrece ejemplos pertinentes a la vida de los etudiantes.", "4.1 Comunica ideas y conceptos con claridad en los diferentes ambientes de aprendizaje y ofrece ejemplos pertinentes a la vida de los etudiantes.", "4.2 Aplica estrategias de aprendizaje y soluciones creativas ante contingencias, teniendo en cuenta las características de su contexto institucional, y utilizando los recursos y materiales dispnibles de manera adecuada.", "4.5 Utiliza la tecnología de la información y la comunicación con una aplicación didáctica y estratégica en distintos ambientes de aprendizaje", "6.2 Favorece entre los estudiantes el deseo de aprender y les proporciona oportunidades y herramientas para avanzar en sus procesos de construcción del conocimiento.", "6.3 Promueve el pensamiento crítico, relfexivo y creativo, a partir de los contenidos educativos establecidos, situaciones de actualidad e inquietudes de los estudiantes.", "6.4 Motiva a los estudiantes en lo individual y en grupo, y produce expectativas de superación y desarrollo.", "7.5 Alienta que los estudiantes expresen opiniones personales, en un marco de respeto y las toma en cuenta."]
    
    var arrayParaTableView:[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var arrayDeCompetencias:[modeloCompetencia] = []
    var arrayDeResultados:[Int] = []
    let arrayComlumnas:[String] = ["competencia3_1", "competencia3_3", "competencia4_1", "competencia4_1_1", "competencia4_2", "competencia4_5", "competencia6_2", "competencia6_3", "competencia6_4", "competencia7_5"]
    var puntajeTotal:Int! = 0
    var cantidadNoAplica:Int! = 0
    
    var materia:String = String()
    var idMateria:Int = Int()
    var idParaPasar:Int! = 0
    
    var destalleSeleccion:[modeloEvaluacion] = []
    
    let objetoFileHelper = FileHelper()
    var miBaseDatos:FMDatabase? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor( red: 31/255, green: 66/255, blue:136/255, alpha: 1.0 ).cgColor
        tableView.layer.borderWidth = 2.0
        
        self.title = "DETALLES DE LA EVALUACIÓN"
        print("La materia seleccioneda fue: \(materia)")
        print("El id de la materia es: \(idMateria)")
        
        miBaseDatos = FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: "Evaluacion"))
        armarArray()
        mostrarResultadosConsulta(materia: materia, id: idMateria)
        actualizarResultado(id: idMateria)
        docenteConCompetencias(id: idMateria, puntaje: puntajeTotal, noAplica: cantidadNoAplica)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mostrarResultadosConsulta(materia:String, id:Int){
        
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            
            /*Aquí sería para sacar todo*/
            let queryParaTodo = "SELECT * FROM evaluaciones WHERE materia = '"+materia+"' AND id = '\(id)'"
            let resultadosTodos:FMResultSet? = miBaseDatos!.executeQuery(queryParaTodo, withArgumentsIn: [])
            
            while resultadosTodos!.next() == true{
                let materiasDelMaestro = modeloEvaluacion(id: Int(resultadosTodos!.int(forColumn: "id")), profesor: resultadosTodos!.string(forColumn: "profesor")!, materia: resultadosTodos!.string(forColumn: "materia")!, semestre: Int(resultadosTodos!.int(forColumn: "semestre")), periodo: Int(resultadosTodos!.int(forColumn: "periodo")), fecha: resultadosTodos!.string(forColumn: "fecha")!, competencia3_1: Int(resultadosTodos!.int(forColumn: "competencia3_1")), competencia3_3: Int(resultadosTodos!.int(forColumn: "competencia3_3")), competencia4_1: Int(resultadosTodos!.int(forColumn: "competencia4_1")), competencia4_1_1: Int(resultadosTodos!.int(forColumn: "competencia4_1_1")), competencia4_2: Int(resultadosTodos!.int(forColumn: "competencia4_2")), competencia4_5: Int(resultadosTodos!.int(forColumn: "competencia4_5")), competencia6_2: Int(resultadosTodos!.int(forColumn: "competencia6_2")), competencia6_3: Int(resultadosTodos!.int(forColumn: "competencia6_3")), competencia6_4: Int(resultadosTodos!.int(forColumn: "competencia6_4")), competencia7_5: Int(resultadosTodos!.int(forColumn: "competencia7_5")), puntaje: Int(resultadosTodos!.int(forColumn: "puntaje")), observaciones: resultadosTodos!.string(forColumn: "observaciones")!)
                destalleSeleccion.append(materiasDelMaestro)
                
                labelNombreProfesor.text = resultadosTodos!.string(forColumn: "profesor")
                labelMateria.text = resultadosTodos!.string(forColumn: "materia")
                labelSemestre.text = String(Int(resultadosTodos!.int(forColumn: "semestre")))
                labelPeriodo.text = String(Int(resultadosTodos!.int(forColumn: "periodo")))
                labelFecha.text = resultadosTodos!.string(forColumn: "fecha")
                labelPuntaje.text = String(Int(resultadosTodos!.int(forColumn: "puntaje")))
                labelObservaciones.text = resultadosTodos!.string(forColumn: "observaciones")!
                idParaPasar = Int(resultadosTodos!.int(forColumn: "id"))
                
            }
            
            /*Cerrar base de datos*/
            miBaseDatos?.close()
            
        }else{
            print("Error al abrir base de datos.")
        }
        
    }
    
    /*Cantidad de No Aplica y Resultado*/
    func actualizarResultado(id:Int){
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
                labelNoAplica.text = String(cantidadNoAplica)
            }else{
                labelNoAplica.text = "0"
            }
            
            /*Colocar elementos en array*/
            for index in 0..<(arrayParaTableView.count){
                switch arrayDeResultados[index]{
                case -3:
                    arrayParaTableView[index] = arrayDeCompetencias[index].noAplica
                case 0:
                    arrayParaTableView[index] = arrayDeCompetencias[index].nivel0
                case 1:
                    arrayParaTableView[index] = arrayDeCompetencias[index].nivel1
                case 2:
                    arrayParaTableView[index] = arrayDeCompetencias[index].nivel2
                case 3:
                    arrayParaTableView[index] = arrayDeCompetencias[index].nivel3
                default:
                    print("Yo soy español español español español.")
                }
            }
            
            /*Cerrar base de datos*/
            miBaseDatos?.close()
        }else{
            print("Error al abrir base de datos.")
        }
    }
    
    /*Armar array con los resultados de las competencias*/
    func armarArray(){
        let path = Bundle.main.path(forResource: "competencias", ofType: "plist")! as String
        let url = URL(fileURLWithPath: path)
        
        do{
            let data = try Data(contentsOf: url)
            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            let dicArray = plist as! [[String:String]]
            for inicio in dicArray{
                arrayDeCompetencias.append(modeloCompetencia(nivel3: inicio["Nivel_3"]!, nivel2: inicio["Nivel_2"]!, nivel1: inicio["Nivel_1"]!, nivel0: inicio["Nivel_0"]!, noAplica: inicio["No_Aplica"]!))
            }
        }catch{
            print("No podemos acceder al archivo.")
        }
    }
    
    /*Verificar si es docente con competencias*/
    func docenteConCompetencias(id:Int, puntaje:Int, noAplica:Int){
        switch noAplica{
        case 0:
            if (puntaje>=20 && puntaje<=30){
                labelResultado.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelResultado.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        case 1:
            if (puntaje>=17 && puntaje<=27){
                labelResultado.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelResultado.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        case 2:
            if (puntaje>=14 && puntaje<=24){
                labelResultado.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelResultado.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        case 3:
            if (puntaje>=11 && puntaje<=21){
                labelResultado.text = "Docente con tendencia a la enseñanza por competencias."
            }else{
                labelResultado.text = "Docente sin tendencia a la enseñanza por competencias."
            }
        default:
            print("Quero mi lechita.")
        }
    }
    
    /*Botón para una editar las observaciones*/
    @IBAction func btnEditar(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "editarObservaciones") as! editarVC
        navigationController?.pushViewController(vc, animated: true)
        vc.idEntrante = idParaPasar
    }
    

}

/*Protocolos y delegados para el Table View*/
extension detallesVC: UITableViewDataSource{
    
}

extension detallesVC: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayParaTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let concepto = arrayTituloCompetencias[indexPath.row]
        let resultado = arrayParaTableView[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaCompetencia", for: indexPath) as! celdaDetalles
        cell.labelResultado.text = resultado
        cell.labelConcepto.text = concepto
        cell.viewConcepto.layer.borderColor = UIColor.darkGray.cgColor
        cell.viewCompetencia.layer.borderColor = UIColor.darkGray.cgColor
        cell.viewCompetencia.layer.borderWidth = 2
        cell.viewConcepto.layer.borderWidth = 2
        return cell
    }
}

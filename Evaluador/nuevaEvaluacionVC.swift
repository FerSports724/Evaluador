//
//  nuevaEvaluacionVC.swift
//  Evaluador
//
//  Created by FERNANDO on 30/08/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class nuevaEvaluacionVC: UIViewController {
    
    /*Fecha*/
    lazy var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    /*Fin fecha*/
    
    var hemosPuchadoSalir:Bool = false
    var maestroSeleccionado = String()
    var idParaColocar:Int!
    var observacionesDocente = ""
    
    var arrayCompetencias:[modeloCompetencia] = []
    var arrayParaPonerEnCollection:[String] = ["3. Emplea actividades que permiten a los estudiantes participar y relacionar el contenido nuevo con algo que ya conoce (discusiones guiadas, lluvia de ideas, hipótesis, opiniones, analogías, diálogo, mapas, redes, cuestionarios).", "2. Emplea actividades que permiten a los estudiantes parcialmente retomar los conocimientos previos (con poca participación de los estudiantes).", "1. Intenta retomar los conocimientos previos empleando sólo su exposición y con nula participación de los estudiantes.", "0. No retoma los conocimientos previos de los estudiantes y empieza la explicación o desarrollo de la clase.", "N/A. El atributo no se puede observar, ya que las actividades programadas no lo contemplan."]
    
    let arrayNivel = ["Nivel 3", "Nivel 2", "Nivel 1", "Nivel 0", "No Aplica"]
    
    var arrayDeResultados = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
    var itemPickerSelected:Int! = 3
    var itemSegmentedSelected:Int! = 0
    var actualRowSelected:String = ""
    var haGiradoPicker:Bool = false
    var valorQueQuedo:Int!
    var puntajeObtenido:Int!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var labelCompetenciaGeneral: UILabel!
    @IBOutlet var labelCompetenciaAtributo: UILabel!
    @IBOutlet var labelHerramientas: UILabel!
    
    @IBOutlet var profesorTextField: UITextField!
    @IBOutlet var materiaTextField: UITextField!
    @IBOutlet var semestreTextField: UITextField!
    @IBOutlet var periodoTextField: UITextField!
    @IBOutlet var fechaTextField: UITextField!
    
    @IBOutlet var saveBarButton: UIBarButtonItem!
    
    let objetoFileHelper = FileHelper()
    var miBaseDatos:FMDatabase? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        materiaTextField.delegate = self
        semestreTextField.delegate = self
        periodoTextField.delegate = self
        
        /*Ver si hemosPuchado es falso*/
        if hemosPuchadoSalir{
            print("Verdadero")
        }else{
            print("Falso")
        }
        
        /*Aquí configuramos el espaciado*/
        let itemSize = UIScreen.main.bounds.width/5 - 4
        let itemSize2 = UIScreen.main.bounds.height/3.9 - 0
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize2)
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        collectionView.collectionViewLayout = layout
        
        armaldoArreglo()
        itemSegmentedSelected = 0
        
        labelHerramientas.text = ""
        print("Ingresaremos un nuevo registro para: \(maestroSeleccionado)")
        miBaseDatos = FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: "Evaluacion"))
        seleccionarID()
        colocarDatosUI()
        print("El id para colocar será: \(idParaColocar!)")
        self.hideKeyboardWhenTappedAround()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        guardarDatos(id: idParaColocar, profesor: profesorTextField.text!, materia: materiaTextField.text!, semestre: Int(semestreTextField.text!)!, periodo: Int(periodoTextField.text!)!, fecha: fechaTextField.text!, competencia3_1: arrayDeResultados[0], competencia3_3: arrayDeResultados[1], competencia4_1: arrayDeResultados[2], competencia4_1_1: arrayDeResultados[3], competencia4_2: arrayDeResultados[4], competencia4_5: arrayDeResultados[5], competencia6_2: arrayDeResultados[6], competencia6_3: arrayDeResultados[7], competencia6_4: arrayDeResultados[8], competencia7_5: arrayDeResultados[9], puntaje: puntajeObtenido, observaciones: observacionesDocente)
    }
    
    /*Función para Segmented Control*/
    @IBAction func accionSegmentedControl(_ sender: UISegmentedControl) {
        itemSegmentedSelected = segmentedControl.selectedSegmentIndex
        actualizarLabels(index: itemSegmentedSelected)
        print("-----------------------------")
        print("La Columna que se quedó es: \(actualRowSelected), y su valor es: \(itemPickerSelected!)")
        print("Hemos girado el picker: \(haGiradoPicker)")
        if haGiradoPicker == false{
            valorEnArray(seleccion: actualRowSelected)
        }
    arrayParaPonerEnCollection=[arrayCompetencias[itemSegmentedSelected].nivel3, arrayCompetencias[itemSegmentedSelected].nivel2, arrayCompetencias[itemSegmentedSelected].nivel1, arrayCompetencias[itemSegmentedSelected].nivel0, arrayCompetencias[itemSegmentedSelected].noAplica]
        
        collectionView.reloadData()
        
    }
    
    /*Seleccionar el ID subsecuente.*/
    func seleccionarID(){
        var arrayId:[Int] = []
        /*Abrir la base de datos*/
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let queryParaTodo = "SELECT id FROM evaluaciones"
            let resultadosTodos:FMResultSet? = miBaseDatos!.executeQuery(queryParaTodo, withArgumentsIn: [])
            while resultadosTodos!.next() == true{
                arrayId.append(Int(resultadosTodos!.int(forColumn: "id")))
            }
            idParaColocar = arrayId.last! + 1
            /*Cerrar base de datos*/
            
            miBaseDatos?.close()
        }else{
            print("Error al abrir base de datos.")
        }
    }
    
    /*Colocar los datos en TextFields*/
    func colocarDatosUI(){
        /*Fecha*/
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "MM/dd/yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        print(myStringafd)
        
        profesorTextField.text = maestroSeleccionado
        fechaTextField.text = myStringafd
    }
    
    /*Función para decidir qué valor irá en el array*/
    func valorEnArray(seleccion:String){
        switch seleccion {
        case "Nivel 3":
            itemPickerSelected = 3
            arrayDeResultados[itemSegmentedSelected] = itemPickerSelected
            print("Tres")
        case "Nivel 2":
            itemPickerSelected = 2
            arrayDeResultados[itemSegmentedSelected] = itemPickerSelected
            print("Dos")
        case "Nivel 1":
            itemPickerSelected = 1
            arrayDeResultados[itemSegmentedSelected] = itemPickerSelected
            print("Uno")
        case "Nivel 0":
            itemPickerSelected = 0
            arrayDeResultados[itemSegmentedSelected] = itemPickerSelected
            print("Cero")
        case "No Aplica":
            itemPickerSelected = -3
            arrayDeResultados[itemSegmentedSelected] = itemPickerSelected
            print("N/A")
        default:
            print("Soy un gatito.")
        }
    }
    
    /*Actualizar las labels de acuerdo al Index seleccionado del Segmented Control*/
    func actualizarLabels(index:Int){
        switch index {
        case 0:
            labelCompetenciaGeneral.text = "3. Planifica los procesos de enseñanza y de aprendizaje atendiendo al enfoque por competencias, y los ubica en contextos disciplinares, curriculares y sociales amplios."
            labelCompetenciaAtributo.text = "3.1 Identifica los conocimientos previos y necesidades de formación de los estudiantes, y desarrolla estrategias para avanzar a partir de ellas."
            labelHerramientas.text = ""
        case 1:
            labelCompetenciaGeneral.text = "3. Planifica los procesos de enseñanza y de aprendizaje atendiendo al enfoque por competencias, y los ubica en contextos disciplinares, curriculares y sociales amplios."
            labelCompetenciaAtributo.text = "3.3 Diseña y utiliza en el salón de clases materiales apropiados para el desarrollo de competencias."
            labelHerramientas.text = ""
        case 2, 3:
            labelCompetenciaGeneral.text = "4. Lleva a la práctica procesos de enseñanza y de aprendizaje de manera efectiva, creativa e innovadora a su contexto institucional."
            labelCompetenciaAtributo.text = "4.1 Comunica ideas y conceptos con claridad en los diferentes ambientes de aprendizaje y ofrece ejemplos pertinentes a la vida de los estudiantes."
            labelHerramientas.text = ""
        case 4:
            labelCompetenciaGeneral.text = "4. Lleva a la práctica procesos de enseñanza y de aprendizaje de manera efectiva, creativa e innovadora a su contexto institucional."
            labelCompetenciaAtributo.text = "4.2 Aplica estrategias de aprendizaje y soluciones creativas ante contingencias, teniendo en cuenta las características de su contexto institucional, y utilizando los recursos y materiales disponibles de manera adecuada."
            labelHerramientas.text = ""
        case 5:
            labelCompetenciaGeneral.text = "4. Lleva a la práctica procesos de enseñanza y de aprendizaje de manera efectiva, creativa e innovadora a su contexto institucional."
            labelCompetenciaAtributo.text = "4.5 Utiliza la tecnología de la información y la comunicación con una aplicación didáctica y estratégica en distintos ambientes de aprendizaje."
            labelHerramientas.text = ""
        case 6:
            labelCompetenciaGeneral.text = "6. Construye ambientes para el aprendizaje autónomo y colaborativo."
            labelCompetenciaAtributo.text = "6.2 Favorece entre los estudiantes el deseo de aprender y les proporcicona oportunidades y herramientas para avanzar en sus procesos de construcción del conocimiento."
            labelHerramientas.text = ""
        case 7:
            labelCompetenciaGeneral.text = "6. Construye ambientes para el aprendizaje autónomo y colaborativo."
            labelCompetenciaAtributo.text = "6.3 Promueve el pensamiento crítico, relfexivo y creativo, a partir de los contenidos educativos establecidos, situaciones de actualidad e inquietudes de los estudiantes."
            labelHerramientas.text = "a) Trabajo colaborativo - b) Resolución de tareas/problema - c) Elaboración de organizadores gráficos - d) Ejercicios que involucran la toma de decisiones - e) Foros - f) Debates - g) Flipped Classroom - h) Trabajo por proyectos - i) Análisis de casos - j) Gamificación"
        case 8:
            labelCompetenciaGeneral.text = "6. Construye ambientes para el aprendizaje autónomo y colaborativo."
            labelCompetenciaAtributo.text = "6.4 Motiva a los estudiantes en lo individual y en grupo, produce expectativas de superación y desarrollo."
            labelHerramientas.text = ""
        case 9:
            labelCompetenciaGeneral.text = "7. Contribuye a la generación de un ambiente que facilite el desarrollo sano e integral de los estudiantes."
            labelCompetenciaAtributo.text = "7.5 Alienta que los estudiantes expresen opiniones personales, en un marco de respeto y las toma en cuenta."
            labelHerramientas.text = ""
        default:
            print("Woof woof")
        }
    }
    
    /*Función que nos dice si el Picker ha sido girado*/
    func hemosTerminadoDeGirar(){
        haGiradoPicker = false
    }
    
    /*Botón para guardar el registro*/
    @IBAction func btnGuardarRegistro(_ sender: UIBarButtonItem) {
        puntajeObtenido = arrayDeResultados.reduce(0, +)
        
            if (materiaTextField.hasText) && (semestreTextField.hasText) && (periodoTextField.hasText){
                guardarDatos(id: idParaColocar, profesor: profesorTextField.text!, materia: materiaTextField.text!, semestre: Int(semestreTextField.text!)!, periodo: Int(periodoTextField.text!)!, fecha: fechaTextField.text!, competencia3_1: arrayDeResultados[0], competencia3_3: arrayDeResultados[1], competencia4_1: arrayDeResultados[2], competencia4_1_1: arrayDeResultados[3], competencia4_2: arrayDeResultados[4], competencia4_5: arrayDeResultados[5], competencia6_2: arrayDeResultados[6], competencia6_3: arrayDeResultados[7], competencia6_4: arrayDeResultados[8], competencia7_5: arrayDeResultados[9], puntaje: puntajeObtenido, observaciones: observacionesDocente)
                
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerFinal") as? confirmarRegistroVC{
                    navigationController?.pushViewController(vc, animated: true)
                    vc.idDelRegistro = idParaColocar
                    //present(vc, animated: true, completion: nil)
            }
            }else{
                let alert = UIAlertController(title: "Error", message: "Faltan por llenar campos.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
        }
        
    }
    
    /*Función para guardar*/
    func guardarDatos(id:Int, profesor:String, materia:String, semestre:Int, periodo:Int, fecha:String, competencia3_1:Int, competencia3_3:Int, competencia4_1:Int, competencia4_1_1:Int, competencia4_2:Int, competencia4_5:Int, competencia6_2:Int, competencia6_3:Int, competencia6_4:Int, competencia7_5:Int, puntaje:Int, observaciones:String){
        
        /*Abrir la base de datos*/
        if (miBaseDatos?.open())!{
            /*Crear Query*/
            let insertarDatos = "INSERT INTO evaluaciones VALUES ('\(id)','\(profesor)','\(materia)','\(semestre)','\(periodo)','\(fecha)','\(competencia3_1)','\(competencia3_3)','\(competencia4_1)','\(competencia4_1_1)','\(competencia4_2)','\(competencia4_5)','\(competencia6_2)','\(competencia6_3)','\(competencia6_4)','\(competencia7_5)','\(puntaje)','\(observaciones)')"
            
            let resultadoGuardar = miBaseDatos!.executeUpdate(insertarDatos, withArgumentsIn: [])
            
            if resultadoGuardar{
                print("Se ha guardado un registro")
            }else{
                print("Error en base de datos: \(miBaseDatos!.lastErrorMessage())")
            }
            /*Cerrar base de datos*/
            
            miBaseDatos?.close()
        }else{
            print("Error al abrir base de datos.")
        }
    }
    
    /*Función Para Anotar Observaciones*/
    @IBAction func btnObservaciones(_ sender: UIBarButtonItem) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueObservaciones"{
            let observacionesView = segue.destination as! observacionesVC
            observacionesView.idQueLlegue = idParaColocar
            observacionesView.observacionesText = observacionesDocente
            
            observacionesView.onSave = onSave
        }
    }
    
    /*Función onSave*/
    func onSave(_ data: String) -> (){
        observacionesDocente = data
    }
    
    
    /*Armar el array con las competencias*/
    func armaldoArreglo(){
        let path = Bundle.main.path(forResource: "competencias", ofType: "plist")! as String
        let url = URL(fileURLWithPath: path)
        
        do{
            let data = try Data(contentsOf: url)
            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            let dicArray = plist as! [[String:String]]
            for inicio in dicArray{
                arrayCompetencias.append(modeloCompetencia(nivel3: inicio["Nivel_3"]!, nivel2: inicio["Nivel_2"]!, nivel1: inicio["Nivel_1"]!, nivel0: inicio["Nivel_0"]!, noAplica: inicio["No_Aplica"]!))
            }
        }catch{
            print("No podemos acceder al archivo.")
        }
    }
    
    
}

/*Esconder teclado con un touch fuera.*/
extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

/*Delegado para esconder el teclado con intro*/
extension nuevaEvaluacionVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

/*Delegados y protocolos del CollectionView*/
extension nuevaEvaluacionVC: UICollectionViewDataSource{
    
}

extension nuevaEvaluacionVC: UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let evaluacion = arrayParaPonerEnCollection[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaCompetencias", for: indexPath) as! celdaCompetencias
        cell.labelCellComp.text = evaluacion
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        return cell
        
    }
    
}

/*Delegados y protocolos del Picker View*/
extension nuevaEvaluacionVC: UIPickerViewDataSource{
    
}

extension nuevaEvaluacionVC: UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayNivel[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayNivel.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        haGiradoPicker = true
        print("\(arrayNivel[row])-> Hemos girado el picker: \(haGiradoPicker)")
        actualRowSelected = arrayNivel[row]
        valorEnArray(seleccion: arrayNivel[row])
        hemosTerminadoDeGirar()
    }
    
}

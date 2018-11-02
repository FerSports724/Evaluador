//
//  ViewController.swift
//  Evaluador
//
//  Created by FERNANDO on 27/08/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var arrayMaestro:[modeloMaestro] = []
    var maestro:modeloMaestro!

    override func viewDidLoad() {
        super.viewDidLoad()
        armaldoArreglo()
        
        /*Aquí configuramos el espaciado*/
        let itemSize = UIScreen.main.bounds.width/3 - 2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        collectionView.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Jalando Datos del plist*/
    func armaldoArreglo(){
        let path = Bundle.main.path(forResource: "infoMaestros", ofType: "plist")! as String
        let url = URL(fileURLWithPath: path)
        
        do{
            let data = try Data(contentsOf: url)
            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            let dicArray = plist as! [[String:String]]
            for inicio in dicArray{
                arrayMaestro.append(modeloMaestro(id: inicio["id"]!, nombre: inicio["profesor"]!, selector: inicio["selector"]!, imagen: inicio["imagen"]!))
            }
        }catch{
            print("No podemos acceder al archivo.")
        }
    }
    
    


}

extension ViewController:UICollectionViewDataSource{
    
}

extension ViewController:UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMaestro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let maestro = arrayMaestro[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaMaestro", for: indexPath) as! celdaMaestro
        cell.imagenMaestro.image = UIImage(named: maestro.imagen)
        return cell
    }
    
    
    
    /*Pasar datos*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueEvaluacion", sender: arrayMaestro[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEvaluacion"{
            if let destinationVC = segue.destination as? tablaEvaluacionesVC{
                if let atractiveSelected = sender as? modeloMaestro{
                    destinationVC.maestroSeleccionado = atractiveSelected.nombre
                    destinationVC.selectorMaestro = atractiveSelected.selector
                }
            }
        }
        
    }
    
}

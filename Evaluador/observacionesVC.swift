//
//  observacionesVC.swift
//  Evaluador
//
//  Created by FERNANDO on 01/10/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class observacionesVC: UIViewController {
    
    var idQueLlegue = Int()
    var observacionesText = String()
    
    /*Callback*/
    var onSave: ((_ data: String) -> ())?
    
    @IBOutlet var vista: UIView!
    @IBOutlet var textViewObs: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("El id es: \(idQueLlegue)")
        colocarObservaciones()
        vista.layer.cornerRadius = 10
        vista.layer.masksToBounds = true
    }
    
    @IBAction func btnGuardarObs(_ sender: UIButton) {
        onSave?(textViewObs.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*Colocar observaciones*/
    func colocarObservaciones(){
        textViewObs.text = observacionesText
    }
}

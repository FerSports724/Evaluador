//
//  celdaDetalles.swift
//  Evaluador
//
//  Created by FERNANDO on 26/09/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class celdaDetalles: UITableViewCell {
    
    @IBOutlet var labelConcepto: UILabel!
    @IBOutlet var labelResultado: UILabel!
    
    @IBOutlet var viewConcepto: UIView!
    @IBOutlet var viewCompetencia: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

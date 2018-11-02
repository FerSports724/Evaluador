//
//  celdaRegistroMateria.swift
//  Evaluador
//
//  Created by FERNANDO on 28/08/18.
//  Copyright © 2018 Fernando Vázquez Bernal. All rights reserved.
//

import UIKit

class celdaRegistroMateria: UITableViewCell {

    @IBOutlet var labelMateria: UILabel!
    @IBOutlet var labelFecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

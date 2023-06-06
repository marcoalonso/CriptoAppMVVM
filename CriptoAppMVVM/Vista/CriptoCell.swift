//
//  CriptoCell.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 06/06/23.
//

import UIKit

class CriptoCell: UITableViewCell {
    
    @IBOutlet weak var precioCriptomoneda: UILabel!
    @IBOutlet weak var nombreCriptomoneda: UILabel!
    
    @IBOutlet weak var fechaCriptomoneda: UILabel!
    @IBOutlet weak var logoCriptomoneda: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

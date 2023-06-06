//
//  CriptoDetalleViewController.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 06/06/23.
//

import UIKit

class CriptoDetalleViewController: UIViewController {
    
    var recibirMoneda: Criptomoneda?
    
    @IBOutlet weak var logoMoneda: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurarVista()
    }
    
    private func configurarVista(){
        guard let monedaRecibida = recibirMoneda else { return }
        self.navigationItem.title = monedaRecibida.nombre
        logoMoneda.image = monedaRecibida.logo
        fecha.text = monedaRecibida.fecha
        precioLabel.text = monedaRecibida.precio
    }

    

}

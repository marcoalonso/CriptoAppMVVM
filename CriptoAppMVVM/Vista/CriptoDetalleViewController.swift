//
//  CriptoDetalleViewController.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 06/06/23.
//

import UIKit
import Combine

class CriptoDetalleViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var logoMoneda: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var precioLabel: UILabel!
    
    
    var viewModel: DetalleMonedaViewModel?
    var recibirMoneda: Criptomoneda?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurarBindingsViewModel()
        
        configurarVista()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.checkInternetConnectivity()
    }
    
    private func configurarVista(){
        guard let monedaRecibida = recibirMoneda else { return }
        self.navigationItem.title = monedaRecibida.nombre
        logoMoneda.image = UIImage(named: monedaRecibida.logo)
        fecha.text = monedaRecibida.fecha
        precioLabel.text = monedaRecibida.precio
        activityIndicatorLoading.isHidden = true
    }
    
    private func ocultarLoader() {
        activityIndicatorLoading.stopAnimating()
        activityIndicatorLoading.isHidden = true
    }

    private func configurarBindingsViewModel() {
        ///-* Se crea un binding de la propiedad showLoading para mostrar/ocultar un activity indicator
        viewModel?.$showLoading.sink { [weak self] showLoading in
            if showLoading {
                self?.activityIndicatorLoading.isHidden = false
                self?.activityIndicatorLoading.startAnimating()
            } else {
                self?.ocultarLoader()
            }
        }.store(in: &cancellables)
        
        ///-* Se crea el binding para escuchar cuando cambia el valor de $bitcoinPrice y poder actualizar la vista
        viewModel?.$bitcoinPrice.sink { [weak self] price in
            self?.precioLabel.text = price
        }.store(in: &cancellables)
        
        ///-* Se crea el binding para escuchar cuando cambia el valor de $dateLastPrice y poder actualizar la vista
        viewModel?.$dateLastPrice.sink { [weak self] date in
            self?.fecha.text = date
        }.store(in: &cancellables)
        
        viewModel?.$internetConnection.sink { [weak self] connection in
            if !connection {
                //Show alert
                DispatchQueue.main.async {
                    self?.mostrarAlerta(titulo: "Atención", mensaje: "No tienes conexion a internet para actualizar el precio de la moneda seleccionada. Verifica e intenta de nuevo.")
                }
            }
        }.store(in: &cancellables)
        
        
        
        viewModel?.$errorMessage.sink { [weak self] error in
            if error != "" {
                DispatchQueue.main.async {
                    self?.mostrarAlerta(titulo: "Atención", mensaje: error)
                    print("Debug: $errorMessage \(error)")

                    self?.ocultarLoader()
                }
            }
        }.store(in: &cancellables)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "OK", style: .default) { _ in
            //Do something
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    private func getPrice(currency: String){
        viewModel?.getPriceCurrency(currency: currency)
    }
}

extension CriptoDetalleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.exchangeRate.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.exchangeRate[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Vibracion
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        
        let currency = viewModel?.exchangeRate[row] ?? "MXN"
        
        getPrice(currency: currency)
    }
    
}

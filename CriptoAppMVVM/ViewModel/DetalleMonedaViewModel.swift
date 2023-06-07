//
//  DetalleMonedaViewModel.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import Foundation
import Combine
import Network

class DetalleMonedaViewModel {
    @Published var bitcoinPrice = "0.0"
    @Published var dateLastPrice = "04 Jun 2023"
    @Published var errorMessage = ""
    @Published var showLoading = false
    @Published var internetConnection = true
    
    var exchangeRate = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let cripto: String
    
    let webservice : Webservice
    
    init(webservice: Webservice, cripto: String) {
        self.webservice = webservice
        self.cripto = cripto
    }
    
    func getPriceCurrency(currency: String) {
        showLoading = true
        
        webservice.getPriceBitcoin(cripto: cripto, currency: currency) { [weak self] currencyObj, error in
            
            if error != nil {
                switch error as? NetworkError {
                case .badResponse:
                    self?.errorMessage = "Hubo un error en el servidor y no está disponible en estos momentos."
                case .badURL:
                    self?.errorMessage = "Hubo un error con la petición y el recurso al que deseas acceder ya no está disponible."
                case .decodingError:
                    self?.errorMessage = "Hubo un error al mostrar los datos."
                case .none:
                    print("Error")
                }
            }
            
            guard let currencyObj = currencyObj else { return }
            
            let precioFormato = currencyObj.rate
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yy, hh:MM:ss"
            
            let date = dateFormatter.string(from: dateFormatter.date(from: currencyObj.time) ?? Date.now)
            
            DispatchQueue.main.async {
                if let formattedAmount = numberFormatter.string(from: NSNumber(value: precioFormato)) {
                    self?.bitcoinPrice = "$\(formattedAmount)"
                    self?.dateLastPrice = date
                    self?.showLoading = false
                }
            }
        }
    }
    
    func checkInternetConnectivity() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            
            if path.usesInterfaceType(.cellular) {
                print("Conection with mobile data")
            } else if path.usesInterfaceType(.wifi) {
                print("Conection with wifi")
            }
            
            if path.status == .satisfied {
                self?.internetConnection = true
            } else {
                self?.internetConnection = false
            }
        }
    }
}

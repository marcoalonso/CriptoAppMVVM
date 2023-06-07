//
//  DetalleMonedaViewModel.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import Foundation
import Combine

class DetalleMonedaViewModel {
    @Published var bitcoinPrice = "0.0"
    @Published var dateLastPrice = "04 Jun 2023"
    @Published var errorMessage = ""
    @Published var showLoading = false
    
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
                self?.errorMessage = "Error: \(error!.localizedDescription)"
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
}

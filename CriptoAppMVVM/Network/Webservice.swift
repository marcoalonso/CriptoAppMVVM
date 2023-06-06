//
//  Webservice.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 06/06/23.
//

import Foundation

class Webservice {
    static let shared = Webservice()
    
    init(){}
    
    func getPriceBitcoin(cripto: String, currency: String, completionHandler: @escaping (_ moneda: CriptomonedaModel?, _ error: Error?) -> ()) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/\(cripto)/\(currency)/?apikey=88E5E5A4-F87E-4FDE-A0CB-7E3664ADDBC0"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, respuesta, error in
                guard let data = data else { return }
                
                let decodificador = JSONDecoder()
                
                do {
                    let dataDecodificada = try decodificador.decode(CriptomonedaModel.self, from: data)
                    print(dataDecodificada)
                    completionHandler(dataDecodificada, nil)
                } catch {
                    print("Debug: error \(error.localizedDescription)")
                    completionHandler(nil, error)
                }
            }.resume()
        }
    }
}
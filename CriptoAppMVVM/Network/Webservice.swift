//
//  Webservice.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 06/06/23.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badResponse
    case decodingError
    case badURL
}

class Webservice {
    static let shared = Webservice()
    let apiKey = "86F7293F-835F-4675-9993-5EBA8D69A333"
    let apiKey2 = "88E5E5A4-F87E-4FDE-A0CB-7E3664ADDBC0"
    let apiKey3 = "8A2D601D-143A-41A2-AF8A-405196B91B4C"
    
    init(){}
    
    func getPriceBitcoin(cripto: String, currency: String, completionHandler: @escaping (_ moneda: CriptomonedaModel?, _ error: Error?) -> ()) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/\(cripto)/\(currency)/?apikey=\(apiKey3)"
        
        do {
            let url = try validateURL(from: urlString)
            print("Debug: url \(url)")

            URLSession.shared.dataTask(with: url) { data, respuesta, error in
                
                if error != nil {
                    completionHandler(nil, NetworkError.badResponse)
                }
                
                guard let data = data else { return }
                
                do {
                    let dataDecodificada = try self.decodeCriptocoins(from: data)
                    
                    completionHandler(dataDecodificada, nil)
                } catch {
                    print("Debug: error \(error.localizedDescription)")
                    completionHandler(nil, NetworkError.decodingError)
                }
            }.resume()
            
        } catch {
            
        }
    }
    
    func validateURL(from string: String) throws -> URL {
        if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
            return url
        } else {
            throw NetworkError.badURL
        }
    }
    
    func decodeCriptocoins(from data: Data) throws -> CriptomonedaModel {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CriptomonedaModel.self, from: data)
            return result
        } catch {
            throw NetworkError.decodingError
        }
    }
}

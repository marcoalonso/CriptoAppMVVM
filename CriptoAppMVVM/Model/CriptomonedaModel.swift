//
//  CriptomonedaModel.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 06/06/23.
//

import Foundation

struct CriptomonedaModel: Codable {
    let time: String
    let rate: Double
    let asset_id_base: String
    let asset_id_quote: String
}

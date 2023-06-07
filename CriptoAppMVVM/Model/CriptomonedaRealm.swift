//
//  CriptomonedaRealm.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import RealmSwift
import UIKit

class CriptomonedaRealm: Object {
    @objc dynamic var nombre: String = ""
    @objc dynamic var logo: String = ""
    @objc dynamic var clave: String = ""
    @objc dynamic var precio: String?
    @objc dynamic var fecha: String?
}


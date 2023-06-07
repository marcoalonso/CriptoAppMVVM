//
//  ApiClientTests.swift
//  CriptoAppMVVMTests
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import XCTest
@testable import CriptoAppMVVM

final class WebserviceTests: XCTestCase {

    func test_WebserviceThrowErrorFromBadURL(){
        let sut = Webservice.shared
        
        do {
            _ = try sut.validateURL(from: "LOREM-IMPSUM")
        } catch (let error){
            XCTAssertEqual(error as! NetworkError, NetworkError.badURL)
        }
    }
    
    func test_WebserviceGetUrlFromGoodURL(){
        let sut = Webservice.shared
        
        let url = try? sut.validateURL(from: "https://rest.coinapi.io/v1/exchangerate/SOL/MXN/?apikey=86F7293F-835F-4675-9993-5EBA8D69A333")
        XCTAssertTrue(url != nil)
    }
    
    func testWebserviceThrowErrorFromBadJSON() {
        let jsonString = "{\"created_at\": \"creation\", \"id_str\": \"id\", \"text\": \"This is an example\", \"user\": { \"name\": \"Wizeboot\", \"screen_name\": \"@wizeboot\", \"description\": \"description\", \"location\": \"location\", \"followers_count\": 100, \"created_at\": \"creation\", \"profile_background_color\": \"red\", \"profile_image_url\": \"url\", \"profile_background_image_url\": \"url\"}, \"favorite_count\": 100, \"retweet_count\": 10}"
        let data = jsonString.data(using: .utf8)!
        
        let sut = Webservice()
        
        do {
            _ = try sut.decodeCriptocoins(from: data)
        } catch(let error) {
            XCTAssertEqual(error as! NetworkError, NetworkError.decodingError)
        }
    }
    
    ///* convert json to string ->  https://jsontostring.com/ -
    func testGetCriptocoinFromGoodJSON(){
        let jsonString = "{\"time\":\"2023-06-07T18:38:31.0000000Z\",\"asset_id_base\":\"BTC\",\"asset_id_quote\":\"USD\",\"rate\":26503.491427019191312420939559}"

        let data = jsonString.data(using: .utf8)!
        
        let sut = Webservice.shared
        
        let monedas = try? sut.decodeCriptocoins(from: data)
        
        XCTAssertTrue(monedas != nil)
    }
    
    func testWebserviceGetPrecio(){
        let sut = Webservice.shared
        let exp = expectation(description: "Esperar a que obtenga los datos")
        
        sut.getPriceBitcoin(cripto: "BTC", currency: "USD") { moneda, error in
            if let moneda = moneda {
                XCTAssertTrue(moneda.rate > 0.0)
                XCTAssertTrue(moneda.time != "")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    private func readLocalJSONFile(fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                print("Error al leer el archivo JSON: \(error)")
                return nil
            }
        } else {
            print("Archivo JSON no encontrado")
            return nil
        }
    }

}

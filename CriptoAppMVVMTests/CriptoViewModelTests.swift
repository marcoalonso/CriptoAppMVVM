//
//  CriptoViewModelTests.swift
//  CriptoAppMVVMTests
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import XCTest
import Combine
@testable import CriptoAppMVVM

final class CriptoViewModelTests: XCTestCase {
    
    var viewModel: CriptoViewModel!
    
    var myViewModel: MyViewModel!
    
    var cancellables: Set<AnyCancellable> = []
    var listaMonedas: [Criptomoneda] = []
    
    override func setUp() {
        super.setUp()
        viewModel = CriptoViewModel(webservice: Webservice.shared)
        myViewModel = MyViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        myViewModel = nil
        cancellables.removeAll()
        listaMonedas.removeAll()
    }

    func test_bindingViewModel(){
        let exp = expectation(description: "conexion hacia monedas del viewModel")
        
        viewModel.$monedas.sink { monedas in
            
            XCTAssertNotNil(monedas)
            XCTAssertTrue(monedas.isEmpty)
            exp.fulfill()
            
        }.store(in: &cancellables)
        
        wait(for: [exp], timeout: 1.0)
    }
    
  
    
    // MARK:  Funcion de prueba
    
    
    func testFetchData() {
            let expectation = self.expectation(description: "Data fetch expectation")
            
            viewModel.fetchData()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTFail("Data fetch failed with error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: { data in
                    // Verificar que los datos devueltos sean los esperados
                    XCTAssertEqual(data, "Hello, World!")
                    expectation.fulfill()
                })
                .store(in: &cancellables)
            
            waitForExpectations(timeout: 1.0, handler: nil)
        }

}

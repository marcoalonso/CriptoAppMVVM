//
//  MyViewModel.swift
//  CriptoAppMVVM
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import Foundation
import Combine

struct Item {
    let id: Int
    let name: String
}

class MyViewModel {
    @Published var items: [Item] = []
    
    func fetchItems() -> AnyPublisher<[Item], Error> {
        // Simulación de la obtención de datos de forma asíncrona con un retraso de 1 segundo
        let publisher = PassthroughSubject<[Item], Error>()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let items = [
                Item(id: 1, name: "Item 1"),
                Item(id: 2, name: "Item 2"),
                Item(id: 3, name: "Item 3")
            ]
            
            publisher.send(items)
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func processItems() {
            fetchItems()
                .sink(receiveCompletion: { completion in
                    // Manejar errores si es necesario
                }, receiveValue: { [weak self] items in
                    // Procesar los items y actualizar el arreglo `items`
                    self?.items = items
                })
                .store(in: &cancellables)
        }
        
        private var cancellables: Set<AnyCancellable> = []
    
}

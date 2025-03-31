//
//  BaseViewModel.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import Foundation
import Combine

class BaseViewModel {
    @Published var isLoading: Bool = false
    
    let errorMessage = PassthroughSubject<String, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
        print("Deinit: \(type(of: self))")
    }
}

//
//  CoinImageViewModel.swift
//  ByteCoin
//
//  Created by GT on 17.03.2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let service: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.service = CoinImageService(coin: coin)
        self.addSubscription()
        self.isLoading = true
    }
    
    private func addSubscription(){
        service.$image.sink { [weak self] (_) in
            self?.isLoading = false
        } receiveValue: { [weak self] (returnedImage) in
            self?.image = returnedImage
        }.store(in: &cancellables)

    }
}

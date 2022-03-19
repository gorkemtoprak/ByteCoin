//
//  MarketDataService.swift
//  ByteCoin
//
//  Created by GT on 18.03.2022.
//

import Foundation
import Combine

class MarketDataService{
    @Published var marketData: MarketDataModel? = nil
    
    var dataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        dataSubscription = NetworkManager.download(url: url).decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                self?.marketData = returnedData.data
                self?.dataSubscription?.cancel()
            })
    }
}

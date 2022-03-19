//
//  CoinDetailDataService.swift
//  ByteCoin
//
//  Created by GT on 19.03.2022.
//

import Foundation
import Combine

class CoinDetailDataService{
    
    @Published var allCoins: CoinDetailModel? = nil
    
    var coinSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinSubscription = NetworkManager.download(url: url).decode(type: CoinDetailModel .self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}

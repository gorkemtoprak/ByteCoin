//
//  HomeViewModel.swift
//  ByteCoin
//
//  Created by GT on 17.03.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinService = CoinDataService()
    private let marketService = MarketDataService()
    private let portfolioService = PortfolioService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(DeveloperPreview.instance.coin)
//            self.portfolioCoins.append(DeveloperPreview.instance.coin)
//        }
        addSubscribers()
    }
    
    func addSubscribers() {
        //updates all coins
        $searchText.combineLatest(coinService.$allCoins).debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins).sink { [weak self] (returnedCoins) in
            self?.allCoins = returnedCoins
        }.store(in: &cancellables)
        
        //Updates market data
        marketService.$marketData.combineLatest($portfolioCoins).map(mapGlobalMarketData).sink { [weak self] (returnedStats) in
            self?.statistics = returnedStats
            self?.isLoading = false
        }.store(in: &cancellables)
        
        //updates portfolio
        $allCoins.combineLatest(portfolioService.$savedEntities).map(mapAllCoinsToPortfolio).sink { [weak self] (returnedCoins) in
            self?.portfolioCoins = returnedCoins
        }.store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioService.updatePorfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinService.getData()
        marketService.getData()
    }
    
    private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return startingCoins
        }
        // Swift is case sensitive
        let lowercasedText = text.lowercased()
        
        let filteredCoins = startingCoins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
        }
        return filteredCoins
    }
    
    private func mapAllCoinsToPortfolio(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel]{
        allCoins.compactMap { (coin) -> CoinModel? in
            guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketData: MarketDataModel?, portCoin: [CoinModel]) -> [StatisticModel]{
        var stat: [StatisticModel] = []
        guard let data = marketData else {
            return stat
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24S Hacim", value: data.volume)
        let dominance = StatisticModel(title: "BTC Dominansı", value: data.btcDominance)
        
        let portValue = portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +)
        
        let prevValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentage = coin.priceChangePercentage24H ?? 0 / 100
            let prevValue = currentValue / (1 + percentage)
            return prevValue
        }.reduce(0, +)
        
        let percentageChange = ((portValue - prevValue) / prevValue) * 100
        
        let portfolio = StatisticModel(title: "Portföy Değeri", value: portValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stat.append(contentsOf: [
            marketCap,
            volume,
            dominance,
            portfolio
        ])
        return stat
    }
}

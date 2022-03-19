//
//  DetailViewModel.swift
//  ByteCoin
//
//  Created by GT on 18.03.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject{
    
    @Published var overviewStat: [StatisticModel] = []
    @Published var additionalStat: [StatisticModel] = []
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    @Published var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        
        coinDetailService.$allCoins.combineLatest($coin).map({ (coinDetailModel, coinModel) ->
            (overviewStat: [StatisticModel], additionalStat: [StatisticModel]) in
            
            //This is for overview stat
            let price = coinModel.currentPrice.asCurrencyWith6Decimals()
            let priceChange = coinModel.priceChangePercentage24H
            let priceStat = StatisticModel(title: "Güncel Fiyat", value: price, percentageChange: priceChange)
            
            let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
            let marketCapChange = coinModel.marketCapChangePercentage24H
            let marketCapStat = StatisticModel(title: "MarketCap", value: marketCap, percentageChange: marketCapChange)
            
            let rank = "\(coinModel.rank)"
            let rankStat = StatisticModel(title: "Sıralama", value: rank)
            
            let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
            let volumeStat = StatisticModel(title: "Hacim", value: volume)
            
            let overview: [StatisticModel] = [
                priceStat,
                marketCapStat,
                rankStat,
                volumeStat
            ]
            
            //This is the additional stat
            let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "nan"
            let highStat = StatisticModel(title: "Yükseliş", value: high)
            
            let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "nan"
            let lowStat = StatisticModel(title: "Düşüş", value: low)
            
            let priceChn = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "nan"
            let priceChnPercentage = coinModel.priceChangePercentage24H
            let pricePercentageStat = StatisticModel(title: "24 Saatlik Değişim", value: priceChn, percentageChange: priceChnPercentage)
            
            let market = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
            let marketCapChng = coinModel.marketCapChangePercentage24H
            let marketStat = StatisticModel(title: "24 Saatlik MarketCap", value: market, percentageChange: marketCapChng)
            
            let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
            let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
            let blockStat = StatisticModel(title: "Blok Süresi", value: blockTimeString)
            
            let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
            let hashingStat = StatisticModel(title: "Hashing Algoritması", value: hashing)
            
            let additional: [StatisticModel] = [
                highStat,
                lowStat,
                pricePercentageStat,
                marketStat,
                blockStat,
                hashingStat
            ]
            
            return (overview, additional)
        })
            .sink { [weak self] (returnedCoinDetails) in
                self?.overviewStat = returnedCoinDetails.overviewStat
                self?.additionalStat = returnedCoinDetails.additionalStat
            print("Received coin detail data")
        }.store(in: &cancellables)
    }
}

//
//  PortfolioView.swift
//  ByteCoin
//
//  Created by GT on 18.03.2022.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var model: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $model.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioSection
                    }
                }
            }.navigationTitle("Portföyü Düzenle").toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 10){
                        Button(action: {
                            saveButtonPressed()
                        }, label: {
                            HStack{
                                Image(systemName: "checkmark")
                                Text("Kaydet".uppercased())
                            }
                        }).opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
                        
                        
                    }.font(.headline)
                }
            }).onChange(of: model.searchText, perform: { value in
                if value == ""{
                    removeSelectedCoin()
                }
            })
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView().environmentObject(dev.homeVM)
    }
}


extension PortfolioView {
    private var coinLogoList: some View{
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10){
                ForEach(model.searchText.isEmpty ? model.portfolioCoins : model.allCoins) { coin in
                    CoinLogoView(coin: coin).frame(width: 75).padding(4).onTapGesture {
                        withAnimation(.easeIn){
                            updateSelectedCoin(coin: coin)
                        }
                    }.background(RoundedRectangle(cornerRadius: 10).stroke(selectedCoin?.id == coin.id ? Color.theme.green: Color.clear , lineWidth: 1.0))
                }
            }.frame(height: 120).padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        if let portCoin = model.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    
    private var portfolioSection: some View {
        VStack(spacing: 20){
            HStack{
                Text("Anlık \(selectedCoin?.symbol.uppercased() ??  "") Fiyatı: ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Elimdeki Miktar: ")
                Spacer()
                TextField("Örn. 2", text: $quantityText).multilineTextAlignment(.trailing).keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Güncel Değeri: ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }.animation(.none).padding().font(.headline)
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed(){
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else { return }
        
        //save to porfolio
        model.updatePortfolio(coin: coin, amount: amount)
        
        //show the checkmark
        withAnimation(.easeIn){
            showCheckmark = true
            removeSelectedCoin()
        }
        
        //hide the keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeIn){
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        model.searchText = ""
    }
}

//
//  HomeView.swift
//  ByteCoin
//
//  Created by GT on 17.03.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var model: HomeViewModel
    @State private var showPortfolio: Bool = false //animates right
    @State private var showPortfolioView: Bool = false //creates new sheet
    @State private var showSettingsView: Bool = false
    @State private var selectCoin: CoinModel? = nil
    @State private var showDetail: Bool = false
        
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea().sheet(isPresented: $showPortfolioView, content: {
                PortfolioView().environmentObject(model)
            })
            VStack{
                homeHeaderExtension
                HomeHeaderView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $model.searchText)
                columnTitle
                
                if !showPortfolio {
                    allCoinsList.transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinsList.transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }.sheet(isPresented: $showSettingsView, content: {
                SettingsView()
            })
        }.background(NavigationLink(
                        destination: DetailLoadingView(coin: $selectCoin),
                        isActive: $showDetail,
                        label: {EmptyView() }))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView().navigationBarHidden(true)
        }.environmentObject(dev.homeVM)
    }
}

extension HomeView {
    
    private var homeHeaderExtension: some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info").animation(.none).onTapGesture {
                if showPortfolio{
                    showPortfolioView.toggle()
                } else {
                    showSettingsView.toggle()
                }
            }.background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Porföyüm" : "Güncel Fiyatlar").font(.headline).fontWeight(.heavy).foregroundColor(Color.theme.accent).animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right").rotationEffect(Angle(degrees: showPortfolio ? 180 : 0)).onTapGesture {
                withAnimation(.spring()){
                    showPortfolio.toggle()
                }
            }
        }.padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(model.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10)).onTapGesture {
                    segue(coin: coin)
                }
            }
        }.listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(model.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10)).onTapGesture {
                    segue(coin: coin)
                }
            }
        }.listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel){
        selectCoin = coin
        showDetail.toggle()
    }
    
    private var columnTitle: some View {
        HStack{
            Text("Coin")
            Spacer()
            Text(showPortfolio ? "Varlıklar" : "")
            Text("Fiyat").frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            Button(action: {
                withAnimation(.linear(duration: 2.0)){
                    model.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            }).rotationEffect(Angle(degrees: model.isLoading ? 360 : 0), anchor: .center)
            
        }.font(.caption).foregroundColor(Color.theme.secondaryText).padding(.horizontal)
    }
}

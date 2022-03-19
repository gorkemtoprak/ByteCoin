//
//  DetailView.swift
//  ByteCoin
//
//  Created by GT on 18.03.2022.
//

import SwiftUI


struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
    
}

struct DetailView: View {
    
    @StateObject private var model: DetailViewModel
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private let spacing: CGFloat = 20
    
    init(coin: CoinModel) {
        _model = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
        
    var body: some View {
        ScrollView{
            VStack{
                ChartView(coin: model.coin).padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                }.padding(.horizontal)
            }
        }.navigationTitle(model.coin.name).toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
        
    }
}

extension DetailView {
    
    private var navigationBarItem: some View{
        HStack {
            Text(model.coin.symbol.uppercased()).font(.headline).foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: model.coin).frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View{
        Text("Genel Bakış").font(.title).bold().foregroundColor(Color.theme.accent).frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(model.overviewStat){ overview in
                    StatisticView(stat: overview)
                }
        })
    }
    
    private var additionalTitle: some View{
        Text("Detaylar").font(.title).bold().foregroundColor(Color.theme.accent).frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalGrid: some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(model.additionalStat){ additional in
                    StatisticView(stat: additional)
                }
        })
    }
}

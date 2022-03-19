//
//  HomeHeaderView.swift
//  ByteCoin
//
//  Created by GT on 18.03.2022.
//

import SwiftUI

struct HomeHeaderView: View {
    
    @EnvironmentObject private var model: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(model.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }.frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(showPortfolio: .constant(false)).environmentObject(dev.homeVM)
    }
}

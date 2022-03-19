//
//  CoinImageView.swift
//  ByteCoin
//
//  Created by GT on 17.03.2022.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject var model: CoinImageViewModel
    
    init(coin: CoinModel) {
        _model = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if let image = model.image {
                Image(uiImage: image).resizable().scaledToFit()
            } else if model.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark").foregroundColor(Color.theme.secondaryText)
            }
            
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin).padding().previewLayout(.sizeThatFits)
    }
}

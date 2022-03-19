//
//  ContentView.swift
//  ByteCoin
//
//  Created by GT on 17.03.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea()
            VStack{
                Text("aa").foregroundColor(Color.theme.red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

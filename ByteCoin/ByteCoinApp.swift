//
//  ByteCoinApp.swift
//  ByteCoin
//
//  Created by GT on 17.03.2022.
//

import SwiftUI

@main
struct ByteCoinApp: App {
    
    @StateObject private var model = HomeViewModel()
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView().navigationBarHidden(true)
            }.environmentObject(model)
        }
    }
}

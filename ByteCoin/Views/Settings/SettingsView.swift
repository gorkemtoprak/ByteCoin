//
//  SettingsView.swift
//  ByteCoin
//
//  Created by GT on 19.03.2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            List{
                Text("Hello, World!")
            }.navigationTitle("Ayarlar").toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

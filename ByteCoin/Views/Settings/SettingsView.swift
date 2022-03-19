//
//  SettingsView.swift
//  ByteCoin
//
//  Created by GT on 19.03.2022.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let personalURL = URL(string: "https://github.com/gorkemtoprak")!
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.theme.background.ignoresSafeArea()
                List{
                    applicationSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }.listStyle(GroupedListStyle()).navigationTitle("Ayarlar").toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMarkButton()
                    }
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

extension SettingsView {
    private var applicationSection: some View {
        Section(header: Text("Uygulama Hakkında")) {
            Link("Şartlar ve Koşullar", destination: defaultURL)
            Link("Gizlilik Sözleşmesi", destination: defaultURL)
            Link("Daha Fazla", destination: defaultURL)
        }
    }
}

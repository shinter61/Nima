//
//  ContentView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameData: GameData
    var body: some View {
        NavigationView {
            if gameData.playerID != "" {
                MainMenu()
            } else {
                RegistPlayerNameView()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView()
                .environmentObject(GameData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

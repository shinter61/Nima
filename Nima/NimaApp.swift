//
//  NimaApp.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI

@main
struct NimaApp: App {
    @StateObject private var gameData = GameData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameData)
        }
    }
}

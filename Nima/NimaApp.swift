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
    @StateObject private var userData = UserData()
    @StateObject private var soundData = SoundData()
    @StateObject private var gameService = GameService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameData)
                .environmentObject(userData)
                .environmentObject(soundData)
                .environmentObject(gameService)
        }
    }
}

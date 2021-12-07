//
//  NimaApp.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI
import GoogleMobileAds

@main
struct NimaApp: App {
    @StateObject private var gameData = GameData()
    @StateObject private var userData = UserData()
    @StateObject private var gameService = GameService()
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameData)
                .environmentObject(userData)
                .environmentObject(gameService)
        }
    }
}

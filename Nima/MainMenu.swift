//
//  MainMenu.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI

struct MainMenu: View {
    @State private var showingGame: Bool = false
    @State private var showingTest: Bool = false
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            Text("二麻")
                .font(.largeTitle)
                .position(x: width/2, y: 0)
            Button(action: {
                showingGame = true
            }) {
                Text("対戦する")
            }
            .position(x: width/2, y: height*0.4)
            
            Button(action: {
                showingTest = true
            }) {
                Text("テストする")
            }
            .position(x: width/2, y: height*0.6)
            
            NavigationLink(
                destination: GameView().navigationBarHidden(true),
                isActive: self.$showingGame
            ) { EmptyView() }
            NavigationLink(
                destination: TestView().navigationBarHidden(true),
                isActive: self.$showingTest
            ) { EmptyView() }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}

//
//  MainMenu.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI

struct MainMenu: View {
    @State private var showingGame: Bool = false
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            Image("chikurin")
                .frame(width: width/2, height: height/2, alignment: .center)
            
            CustomText(content: "二麻", size: 48, tracking: 10)
                .position(x: width*0.3, y: height*0.1)
            
            Button(action: {
                showingGame = true
            }) {
                CustomText(content: "対戦する", size: 24, tracking: 2)
                    .foregroundColor(Color.red)
            }
            .position(x: width*0.3, y: height*0.7)
            
            NavigationLink(
                destination: GameView().navigationBarHidden(true),
                isActive: self.$showingGame
            ) { EmptyView() }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}

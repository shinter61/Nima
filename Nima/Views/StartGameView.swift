//
//  StartGameView.swift
//  Nima
//
//  Created by 松本真太朗 on 2022/01/12.
//

import SwiftUI

struct StartGameView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameData: GameData
    
    @State private var flag: Bool = true

    var body: some View {
        if #available(iOS 15.0, *) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                ZStack {
                    if flag {
                        Path { path in
                            path.move(to: CGPoint(x: -200, y: 0))
                            path.addLine(to: CGPoint(x: Int(UIScreen.main.bounds.width) + 100, y: Int(UIScreen.main.bounds.height)))
                            path.addLine(to: CGPoint(x: -200, y: Int(UIScreen.main.bounds.height)))
                        }
                        .fill(Color.red)
                        .transition(.move(edge: .leading))
                        Path { path in
                            path.move(to: CGPoint(x: -200, y: 0))
                            path.addLine(to: CGPoint(x: Int(UIScreen.main.bounds.width) + 100, y: Int(UIScreen.main.bounds.height)))
                            path.addLine(to: CGPoint(x: Int(UIScreen.main.bounds.width) + 100, y: 0))
                        }
                        .fill(Color.blue)
                        .transition(.move(edge: .trailing))
                        CustomText(content: "対局開始", size: 48, tracking: 8)
                            .foregroundColor(Color.white)
                            .position(x: width/2, y: height/2)
                            .transition(.opacity)
                        VStack {
                            CustomText(content: userData.userName, size: 32, tracking: 0)
                                .foregroundColor(Color.white)
                            CustomText(content: "レーティング: \(userData.rating)", size: 32, tracking: 0)
                                .foregroundColor(Color.white)
                        }
                        .position(x: width*0.3, y: height*0.8)
                        .transition(.move(edge: .leading))
                        VStack {
                            CustomText(content: gameData.opponentName, size: 32, tracking: 0)
                                .foregroundColor(Color.white)
                            CustomText(content: "レーティング: \(gameData.opponentRating)", size: 32, tracking: 0)
                                .foregroundColor(Color.white)
                        }
                        .position(x: width*0.7, y: height*0.2)
                        .transition(.move(edge: .trailing))
                    }
                }
            }
            .task {
                sleep(2)
                withAnimation {
                    self.flag.toggle()
                }
            }
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}

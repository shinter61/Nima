//
//  ExhaustiveDrawView.swift
//  ExhaustiveDrawView
//
//  Created by 松本真太朗 on 2021/10/14.
//

import SwiftUI

struct ExhaustiveDrawView: View {
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                CustomText(content: "流局", size: 36, tracking: 0)
                    .foregroundColor(Colors.init().navy)
                    .position(x: width*0.1, y: height*0.1)
                NameView(name: "\(gameData.playerID)").position(x: width*0.2, y: height*0.25)
                if gameData.myWaits.count != 0 {
                    CustomText(content: "待ち牌：", size: 16, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.4, y: height*0.25)
                    HStack(alignment: .center, spacing: -6, content: {
                        ForEach(gameData.myWaits, id: \.self) { tile in
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 60, alignment: .center)
                        }
                    })
                    .position(x: width*0.6, y: height*0.25)
                    CustomText(content: "+1500", size: 24, tracking: 0)
                        .foregroundColor(Colors.init().green)
                        .position(x: width*0.85, y: height*0.25)
                        
                }
                HStack(alignment: .center, spacing: 0, content: {
                    HStack(alignment: .center, spacing: -6, content: {
                        ForEach(Array(gameData.myTiles.enumerated()), id: \.offset) { index, tile in
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 60, alignment: .center)
                        }
                    })
                    .padding(.trailing, 6)
                    MinkoView()
                    AnkanView()
                    MinkanView()
                })
                .position(x: width*0.5, y: height*0.45)
                NameView(name: "\(gameData.opponentID)").position(x: width*0.2, y: height*0.65)
                if gameData.myWaits.count != 0 {
                    CustomText(content: "待ち牌：", size: 16, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.4, y: height*0.65)
                    HStack(alignment: .center, spacing: -6, content: {
                        ForEach(gameData.myWaits, id: \.self) { tile in
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 60, alignment: .center)
                        }
                    })
                    .position(x: width*0.6, y: height*0.65)
                    CustomText(content: "-1500", size: 24, tracking: 0)
                        .foregroundColor(Colors.init().red)
                        .position(x: width*0.85, y: height*0.65)
                }
                HStack(alignment: .center, spacing: 0, content: {
                    HStack(alignment: .center, spacing: -6, content: {
                        ForEach(Array(gameData.myTiles.enumerated()), id: \.offset) { index, tile in
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 60, alignment: .center)
                        }
                    })
                    .padding(.trailing, 6)
                    MinkoView()
                    AnkanView()
                    MinkanView()
                })
                .position(x: width*0.5, y: height*0.85)
            }
        }
    }
}

struct ExhaustiveDrawView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ExhaustiveDrawView()
                .environmentObject(GameData())
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

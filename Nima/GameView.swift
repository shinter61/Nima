//
//  GameView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameData: GameData
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            Text("残り \(gameData.stock.count)")
                .position(x: width/2, y: height*0.4)
            DiscardsView(discards: gameData.myDiscards)
            .position(x: width/2, y: height*0.6)
            
            Text("あなた 35000点").position(x: width*0.2, y: height*0.8)
            Button(action: {
                gameData.draw()
            }) {
                Text("ツモる")
            }.position(x: width*0.9, y: height*0.8)
            List {
                HStack(alignment: .center, spacing: -4, content: {
                    ForEach(gameData.myTiles, id: \.self) { tile in
                        Button(action: {
                            gameData.discard(tile: tile)
                        }) {
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 60, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                })
            }
            .frame(width: 30*13, height: 70, alignment: .center)
            .listStyle(PlainListStyle())
            .position(x: width/2, y: height*0.9)
        }
        .onAppear {
            gameData.reload()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameData())
    }
}

//
//  AnkanView.swift
//  AnkanView
//
//  Created by 松本真太朗 on 2021/08/31.
//

import SwiftUI

struct AnkanView: View {
    @EnvironmentObject var gameData: GameData
    var playerID: String
    var body: some View {
        if gameData.playerID == playerID {
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(gameData.myAnkans, id: \.self) { tile in
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60, alignment: .center)
                        .padding(-2)
                        .padding(.trailing, 10)
                }
            })
        } else {
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(gameData.yourAnkans, id: \.self) { tile in
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .padding(-2)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .padding(-2)
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .padding(-2)
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .padding(-2)
                        .padding(.trailing, 10)
                }
            })
        }
    }
}

struct AnkanView_Previews: PreviewProvider {
    static var previews: some View {
        AnkanView(playerID: "")
            .environmentObject(GameData())
    }
}

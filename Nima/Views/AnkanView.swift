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
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 60, alignment: .center)
                            .padding(-2)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 30, height: 45, alignment: .center)
                        }
                    }
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 60, alignment: .center)
                            .padding(-2)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 30, height: 45, alignment: .center)
                        }
                    }
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
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 60, alignment: .center)
                            .padding(-2)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 22, height: 34, alignment: .center)
                        }
                    }
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 60, alignment: .center)
                            .padding(-2)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 22, height: 34, alignment: .center)
                        }
                    }
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

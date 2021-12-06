//
//  MinkanView.swift
//  MinkanView
//
//  Created by 松本真太朗 on 2021/08/31.
//

import SwiftUI

struct MinkanView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameData: GameData
    var playerID: Int
    var body: some View {
        if userData.userID == playerID {
            HStack(alignment: .center, spacing: -2, content: {
                ForEach(userData.userID == playerID ? gameData.myMinkans : gameData.yourMinkans, id: \.self) { tile in
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 60, alignment: .center)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 30, height: 45, alignment: .center)
                        }
                    }
                    .padding(-2)
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 60, alignment: .center)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 30, height: 45, alignment: .center)
                        }
                    }
                    .padding(-2)
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55, alignment: .center)
                            .rotationEffect(Angle(degrees: -90.0))
                            .padding(-2)
                            .padding(.bottom, -4)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 30, height: 45, alignment: .center)
                                .rotationEffect(Angle(degrees: -90.0))
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
                    .padding(.trailing, 10)
                }
            })
        } else {
            HStack(alignment: .center, spacing: 4, content: {
                ForEach(userData.userID == playerID ? gameData.myMinkans : gameData.yourMinkans, id: \.self) { tile in
                    ZStack {
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 60, alignment: .center)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 22, height: 34, alignment: .center)
                        }
                    }
                    .padding(-8)
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
                            .frame(width: 30, height: 55, alignment: .center)
                            .rotationEffect(Angle(degrees: -90.0))
                            .padding(-2)
                            .padding(.bottom, -4)
                        if gameData.doraTiles.map { $0.next().name() }.contains(tile.name()) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 22, height: 34, alignment: .center)
                                .rotationEffect(Angle(degrees: -90.0))
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
                    .padding(.trailing, 10)
                }
            })
        }
    }
}

struct MinkanView_Previews: PreviewProvider {
    static var previews: some View {
        MinkanView(playerID: -1)
            .environmentObject(GameData())
            .environmentObject(UserData())
    }
}

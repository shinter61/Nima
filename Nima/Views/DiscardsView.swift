//
//  DiscardsView.swift
//  DiscardsView
//
//  Created by 松本真太朗 on 2021/08/09.
//

import SwiftUI

struct DiscardsView: View {
    @EnvironmentObject var gameData: GameData
    var discards: [Tile]
    var riichiTurn: Int
    
    var body: some View {
        let firstDiscards = Array(tileName(discards: discards)[0..<6])
        VStack(alignment: .leading, spacing: -4, content: {
            HStack(spacing: -2, content: {
                ForEach(Array(firstDiscards.enumerated()), id: \.offset) { index, name in
                    ZStack {
                        if index == riichiTurn - 1 {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(Angle(degrees: -90.0))
                                .frame(width: 28, height: 28)
                            if gameData.doraTiles.map { $0.next().name() }.contains(name) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 16, height: 24, alignment: .center)
                                    .rotationEffect(Angle(degrees: -90.0))
                            }
                        } else {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 30)
                            if gameData.doraTiles.map { $0.next().name() }.contains(name) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 16, height: 24, alignment: .center)
                            }
                        }
                    }
                }
            })
                
            let secondDiscards = Array(tileName(discards: discards)[6..<12])
            HStack(spacing: -2, content: {
                ForEach(Array(secondDiscards.enumerated()), id: \.offset) { index, name in
                    ZStack {
                        if index == riichiTurn - 7 {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(Angle(degrees: -90.0))
                                .frame(width: 28, height: 28)
                            if gameData.doraTiles.map { $0.next().name() }.contains(name) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 16, height: 24, alignment: .center)
                                    .rotationEffect(Angle(degrees: -90.0))
                            }
                        } else {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 30)
                            if gameData.doraTiles.map { $0.next().name() }.contains(name) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 16, height: 24, alignment: .center)
                            }
                        }
                    }
                }
            })
        
            let thirdDiscards = Array(tileName(discards: discards)[12..<20])
            HStack(spacing: -2, content: {
                ForEach(Array(thirdDiscards.enumerated()), id: \.offset) { index, name in
                    ZStack {
                        if index == riichiTurn - 13 {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(Angle(degrees: -90.0))
                                .frame(width: 28, height: 28)
                            if gameData.doraTiles.map { $0.next().name() }.contains(name) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 16, height: 24, alignment: .center)
                                    .rotationEffect(Angle(degrees: -90.0))
                            }
                        } else {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 30)
                            if gameData.doraTiles.map { $0.next().name() }.contains(name) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 16, height: 24, alignment: .center)
                            }
                        }
                    }
                }
            })
        })
    }
    
    func tileName(discards: [Tile]) -> [String] {
        let tileCount = discards.count
        var nameArr: [String] = []
        for i in 0..<tileCount {
            nameArr.append(discards[i].name())
        }
        for _ in 0..<(21-tileCount) {
            nameArr.append("")
        }
        return nameArr
    }
}

struct DiscardsView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            DiscardsView(discards: [
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red"),
                Tile(kind: "", number: 0, character: "red")
            ], riichiTurn: 14)
                .environmentObject(GameData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

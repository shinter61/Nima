//
//  DiscardsView.swift
//  DiscardsView
//
//  Created by 松本真太朗 on 2021/08/09.
//

import SwiftUI

struct DiscardsView: View {
    var discards: [Tile]
    var body: some View {
        let firstDiscards = Array(discards[0..<min(discards.count, 6)])
        VStack(alignment: .leading, spacing: 0, content: {
            List {
                HStack(spacing: 12, content: {
                    ForEach(firstDiscards, id: \.self) { tile in
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 40)
                            .padding(.top, -6)
                            .padding(.leading, -18)
                    }
                })
            }
            .frame(width: 150, height: 40)
            .listStyle(PlainListStyle())
                
            if (discards.count > 6) {
                let secondDiscards = Array(discards[6..<min(discards.count, 12)])
                List {
                    HStack(spacing: 12, content: {
                        ForEach(secondDiscards, id: \.self) { tile in
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 40)
                                .padding(.top, -6)
                                .padding(.leading, -18)
                        }
                    })
                }
                .frame(width: 150, height: 40)
                .listStyle(PlainListStyle())
            }
            
            if (discards.count > 12) {
                let secondDiscards = Array(discards[12..<min(discards.count, 18)])
                List {
                    HStack(spacing: 12, content: {
                        ForEach(secondDiscards, id: \.self) { tile in
                            Image(tile.name())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 40)
                                .padding(.top, -6)
                                .padding(.leading, -18)
                        }
                    })
                }
                .frame(width: 150, height: 40)
                .listStyle(PlainListStyle())
            }
        })
    }
}

struct DiscardsView_Previews: PreviewProvider {
    static var previews: some View {
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
            Tile(kind: "", number: 0, character: "red")
        ])
    }
}

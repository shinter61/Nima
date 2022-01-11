//
//  WaitsView.swift
//  Nima
//
//  Created by 松本真太朗 on 2022/01/11.
//

import SwiftUI

struct WaitsView: View {
    var waits: [Tile]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Colors().navy)
                .frame(width: max(CGFloat(waits.count * 50) + 2, 102), height: 80 + 2, alignment: .center)
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 224/255, green: 224/255, blue: 224/255))
                .frame(width: max(CGFloat(waits.count * 50), 100), height: 80, alignment: .center)
            VStack {
                CustomText(content: "待ち牌", size: 20, tracking: 0)
                    .foregroundColor(Colors().navy)
                    .padding(.bottom, -10)
                HStack {
                    ForEach(Array(waits.enumerated()), id: \.offset) { index, tile in
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 60, alignment: .center)
                    }
                }
            }
        }
    }
}

struct WaitsView_Previews: PreviewProvider {
    static var previews: some View {
        WaitsView(waits: [
            Tile(kind: "sou", number: 1, character: ""),
            Tile(kind: "sou", number: 2, character: ""),
            Tile(kind: "sou", number: 4, character: ""),
            Tile(kind: "sou", number: 5, character: ""),
            Tile(kind: "sou", number: 7, character: ""),
            Tile(kind: "sou", number: 8, character: ""),
        ])
    }
}

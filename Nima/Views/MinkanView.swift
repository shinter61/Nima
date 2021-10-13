//
//  MinkanView.swift
//  MinkanView
//
//  Created by 松本真太朗 on 2021/08/31.
//

import SwiftUI

struct MinkanView: View {
    @EnvironmentObject var gameData: GameData
    var body: some View {
        HStack(alignment: .center, spacing: -2, content: {
            ForEach(gameData.myMinkans, id: \.self) { tile in
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
                Image(tile.name())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55, alignment: .center)
                    .rotationEffect(Angle(degrees: -90.0))
                    .padding(-2)
                    .padding(.bottom, -4)
                Image(tile.name())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 60, alignment: .center)
                    .padding(-2)
                    .padding(.trailing, 10)
            }
        })
    }
}

struct MinkanView_Previews: PreviewProvider {
    static var previews: some View {
        MinkanView()
            .environmentObject(GameData())
    }
}

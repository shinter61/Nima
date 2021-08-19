//
//  MinkoView.swift
//  MinkoView
//
//  Created by 松本真太朗 on 2021/08/19.
//

import SwiftUI

struct MinkoView: View {
    @EnvironmentObject var gameData: GameData
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            ForEach(gameData.myMinkos, id: \.self) { tile in
                Image(tile.name())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 60, alignment: .center)
                    .padding(-2)
                Image(tile.name())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .rotationEffect(Angle(degrees: -90.0))
                    .padding(-2)
                    .padding(.bottom, -4)
                Image(tile.name())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 60, alignment: .center)
                    .padding(-2)
                    .padding(.trailing, 10)
            }
        })
    }
}


struct MinkoView_Previews: PreviewProvider {
    static var previews: some View {
        MinkoView()
            .environmentObject(GameData())
    }
}

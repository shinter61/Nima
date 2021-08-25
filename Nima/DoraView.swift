//
//  DoraView.swift
//  DoraView
//
//  Created by 松本真太朗 on 2021/08/25.
//

import SwiftUI

struct DoraView: View {
    @EnvironmentObject var gameData: GameData
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            Text("ドラ：").padding(.trailing, 16)
            ForEach(gameData.doraTiles, id: \.self) { tile in
                Image(tile.name())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 60, alignment: .center)
                    .padding(-2)
            }
        })
    }
}

struct DoraView_Previews: PreviewProvider {
    static var previews: some View {
        DoraView()
            .environmentObject(GameData())
    }
}

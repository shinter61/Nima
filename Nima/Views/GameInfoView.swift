//
//  GameInfoView.swift
//  GameInfoView
//
//  Created by 松本真太朗 on 2021/10/14.
//

import SwiftUI

struct GameInfoView: View {
    var wind: String
    var round: Int
    var stockCount: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Colors.init().navy)
                .frame(width: 80, height: 80, alignment: .center)
            VStack(alignment: .center, spacing: 4, content: {
                Group {
                    CustomText(content: "\(wind)\(round)局", size: 18, tracking: 0)
                    CustomText(content: "残り \(stockCount)", size: 18, tracking: 0)
                }
                .foregroundColor(Color.white)
                
            })
        }
    }
}

struct GameInfoView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            GameInfoView(wind: "東", round: 1, stockCount: 32)
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

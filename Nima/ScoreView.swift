//
//  ScoreView.swift
//  ScoreView
//
//  Created by 松本真太朗 on 2021/08/15.
//

import SwiftUI

struct ScoreView: View {
    var score: Int
    var scoreName: String
    var hands: [String]
    var body: some View {
        VStack {
            List {
                ForEach(hands, id: \.self) { hand in
                    Text(hand)
                        .font(.system(size: 24, weight: .light, design: .serif))
                }
            }
            .listStyle(PlainListStyle())
            .frame(width: 300, height: 400, alignment: .center)
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10, content: {
                    Group {
                        Text(scoreName)
                        Text("\(score)点")
                    }
                    .font(.system(size: 32, weight: .bold, design: .serif))
                })
                    .padding(.trailing, 50)
            }
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(score: 12000, scoreName: "満貫", hands: ["立直", "自摸", "混一色"])
    }
}

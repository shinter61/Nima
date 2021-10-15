//
//  SubGameInfoView.swift
//  SubGameInfoView
//
//  Created by 松本真太朗 on 2021/10/16.
//

import SwiftUI

struct SubGameInfoView: View {
    @EnvironmentObject var gameData: GameData
    var body: some View {
        HStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .frame(width: 20, height: 50, alignment: .center)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 19, height: 49, alignment: .center)
                    Circle()
                        .fill(Colors.init().red)
                        .frame(width: 6, height: 6, alignment: .center)
                }
                .rotationEffect(Angle(degrees: 20.0))
                CustomText(content: "×\(gameData.kyotaku)", size: 16, tracking: 0)
                    .padding(.trailing, 8)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .frame(width: 20, height: 50, alignment: .center)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 19, height: 49, alignment: .center)
                    VStack(alignment: .center, spacing: 2, content: {
                        HStack(alignment: .center, spacing: 4, content: {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                        })
                        HStack(alignment: .center, spacing: 4, content: {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                        })
                        HStack(alignment: .center, spacing: 4, content: {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                        })
                        HStack(alignment: .center, spacing: 4, content: {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4, alignment: .center)
                        })
                    })
                }
                .rotationEffect(Angle(degrees: 20.0))
                CustomText(content: "×\(gameData.honba)", size: 16, tracking: 0)
            }
        }
    }
}

struct SubGameInfoView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            SubGameInfoView()
                .environmentObject(GameData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

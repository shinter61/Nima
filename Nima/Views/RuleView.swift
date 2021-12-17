//
//  RuleView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/17.
//

import SwiftUI

struct RuleView: View {
    @Binding var showingRule: Bool
    @Binding var isAdTiming: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20, content: {
                CustomText(content: "ルール", size: 32, tracking: 2)
                    .foregroundColor(Colors().navy)
                    .padding(.top, 20)
                Divider()
                HStack(alignment: .top, spacing: 100, content: {
                    Spacer(minLength: 50)
                    VStack(alignment: .leading, spacing: 20, content: {
                        CustomText(content: "東南2局ずつの合計点で競う", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                        CustomText(content: "持ち点35000点", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                        CustomText(content: "飛び終了あり", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                        CustomText(content: "食いタンあり", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                        CustomText(content: "後付けあり", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                        CustomText(content: "赤牌なし", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                    })
                    VStack(alignment: .leading, spacing: 20, content: {
                        CustomText(content: "一発あり", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                        CustomText(content: "裏ドラあり", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                        CustomText(content: "チーなし", size: 20, tracking: 0)
                            .foregroundColor(Colors().navy)
                    })
                    Spacer(minLength: 50)
                })
                Divider()
                CustomText(content: "牌は以下の20種80枚で行う", size: 20, tracking: 0)
                    .foregroundColor(Colors().navy)
                Divider()
                VStack(alignment: .center, spacing: 0, content: {
                    HStack(alignment: .center, spacing: 4, content: {
                        Image("1sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("2sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("3sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("4sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("5sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("6sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("7sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("8sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("9sou").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                    })
                    HStack(alignment: .center, spacing: 4, content: {
                        Image("1pin").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("9pin").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("1man").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Image("9man").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        Group {
                            Image("white").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                            Image("green").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                            Image("red").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                            Image("east").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                            Image("south").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                            Image("west").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                            Image("north").resizable().scaledToFit().frame(width: 40, height: 60, alignment: .center)
                        }
                    })
                })
                Divider()
                Button(action: {
                    isAdTiming = false
                    showingRule = false
                }) {
                    CustomText(content: "戻る", size: 24, tracking: 0)
                        .foregroundColor(Colors().red)
                }
                .padding(.bottom, 40)
            })
        }
    }
}

struct RuleView_Previews: PreviewProvider {
    static var previews: some View {
        RuleView(showingRule: .constant(false), isAdTiming: .constant(false))
    }
}

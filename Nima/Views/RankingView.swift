//
//  RankingView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/17.
//

import SwiftUI

struct RankingView: View {
    @Binding var showingRanking: Bool
    @Binding var isAdTiming: Bool
    
    @State private var users: [User] = [
        User(id: 1, name: "test1", rating: 1000),
        User(id: 2, name: "test2", rating: 1002),
        User(id: 3, name: "test3", rating: 1003),
        User(id: 4, name: "test4", rating: 1000),
        User(id: 5, name: "test5", rating: 1090),
        User(id: 6, name: "test6", rating: 1044),
        User(id: 7, name: "test7", rating: 1000),
        User(id: 8, name: "test8", rating: 1080),
        User(id: 9, name: "test9", rating: 1500),
        User(id: 10, name: "test10", rating: 1500),
        User(id: 11, name: "test11", rating: 1200),
        User(id: 12, name: "test12", rating: 1002),
        User(id: 13, name: "test13", rating: 1033),
        User(id: 14, name: "test14", rating: 1090),
        User(id: 15, name: "test15", rating: 1800),
        User(id: 16, name: "test16", rating: 1090),
        User(id: 17, name: "test17", rating: 1004),
        User(id: 18, name: "test18", rating: 1000),
        User(id: 19, name: "test19", rating: 1040),
        User(id: 20, name: "test20", rating: 1020),
        User(id: 21, name: "test21", rating: 1100),
        User(id: 22, name: "test22", rating: 1030),
        User(id: 23, name: "test23", rating: 1004),
        User(id: 24, name: "test24", rating: 1000),
        User(id: 25, name: "test25", rating: 1003),
        User(id: 26, name: "test26", rating: 1003),
        User(id: 27, name: "test27", rating: 1020),
    ]
    
    func rankColor(rank: Int) -> Color {
        switch rank {
        case 1:
            return Color(red: 204/255, green: 204/255, blue: 0)
        case 2:
            return Color(red: 160/255, green: 160/255, blue: 160/255)
        case 3:
            return Color(red: 179/255, green: 104/255, blue: 0)
        default:
            return Colors().navy
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0, content: {
                CustomText(content: "ランキング", size: 32, tracking: 2)
                    .foregroundColor(Colors().navy)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                Divider()
                HStack(alignment: .center, spacing: 54, content: {
                    CustomText(content: "順位", size: 20, tracking: 0)
                        .foregroundColor(Colors().navy)
                        .frame(width: 120, height: 24, alignment: .center)
                    CustomText(content: "ユーザー名", size: 20, tracking: 0)
                        .foregroundColor(Colors().navy)
                        .frame(width: 120, height: 24, alignment: .center)
                    CustomText(content: "レーティング", size: 20, tracking: 0)
                        .foregroundColor(Colors().navy)
                        .frame(width: 120, height: 24, alignment: .center)
                })
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                Divider()
                ForEach(Array(users.enumerated()), id: \.offset) { index, user in
                    ZStack {
                        if index + 1 == 1 {
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 64, alignment: .center)
                                .shine(.gold)
                        } else if index + 1 == 2 {
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 64, alignment: .center)
                                .shine(.silver)
                        } else if index + 1 == 3 {
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 64, alignment: .center)
                                .shine(.bronze)
                        } else {
                            Rectangle()
                                .fill(.white)
                                .frame(width: UIScreen.main.bounds.width, height: 64, alignment: .center)
                        }
                        HStack(alignment: .center, spacing: 54, content: {
                            CustomText(content: "\(index + 1)", size: 20, tracking: 0)
                                .foregroundColor(Colors().navy)
                                .frame(width: 120, height: 24, alignment: .center)
                            CustomText(content: "\(user.name)", size: 20, tracking: 0)
                                .foregroundColor(Colors().navy)
                                .frame(width: 120, height: 24, alignment: .center)
                            CustomText(content: "\(user.rating)", size: 20, tracking: 0)
                                .foregroundColor(Colors().navy)
                                .frame(width: 120, height: 24, alignment: .center)
                        })
                    }
                    Divider()
                }
                Button(action: {
                    isAdTiming = false
                    showingRanking = false
                }) {
                    CustomText(content: "戻る", size: 24, tracking: 0)
                }
                .padding(.top, 20)
            })
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(showingRanking: .constant(false), isAdTiming: .constant(false))
    }
}

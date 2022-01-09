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
    
    @State private var users: [User] = []
    
    @available(iOS 15.0.0, *)
    func getRanking() async {
        do {
            let sortedUsers: [User] = try await UserService().getRanking()
            DispatchQueue.main.async {
                users = sortedUsers
            }
        } catch(let error) {
            debugPrint(error)
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
        .task {
            await getRanking()
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(showingRanking: .constant(false), isAdTiming: .constant(false))
    }
}

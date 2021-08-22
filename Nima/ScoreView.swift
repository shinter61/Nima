//
//  ScoreView.swift
//  ScoreView
//
//  Created by 松本真太朗 on 2021/08/15.
//

import SwiftUI
import SocketIO

struct ScoreView: View {
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingScore: Bool
    var score: Int
    var scoreName: String
    var hands: [String]
    
    func pop() -> Void {
        gameService.socket.emit("StartGame")
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(hands, id: \.self) { hand in
                    Text(hand)
                        .font(.system(size: 16, weight: .light, design: .serif))
                }
            }
            .listStyle(PlainListStyle())
            .frame(width: 300, height: 200, alignment: .center)
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
            .padding(.bottom, 20)
            Text(String(gameData.countdown))
            if gameData.countdown <= 0 {
                ActionEmptyView(action: pop)
            }
        }
        .onAppear { gameData.start() }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(showingScore: .constant(false), score: 12000, scoreName: "満貫", hands: ["立直", "自摸", "混一色"])
            .environmentObject(GameData())
            .environmentObject(GameService())
    }
}

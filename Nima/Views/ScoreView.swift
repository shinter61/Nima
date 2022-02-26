//
//  ScoreView.swift
//  ScoreView
//
//  Created by 松本真太朗 on 2021/08/15.
//

import SwiftUI
import SocketIO

struct ScoreView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @Environment(\.presentationMode) private var presentationMode
    @Binding var rootIsActive: Bool
    @State private var showingEndGame: Bool = false
    var score: Int
    var scoreName: String
    var hands: [Hand]
    
    func pop() -> Void {
        if (gameData.isGameEnd) {
            gameService.socket.emit("EndGame", gameData.roomID)
            showingEndGame = true
        } else {
            if gameData.roundWinnerID == userData.userID {
                gameService.socket.emit("StartGame", gameData.roomID)
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            NameView(name: "\(gameData.roundWinnerID == userData.userID ? userData.userName : gameData.opponentName)")
                .position(x: width*0.2, y: height*0.15)
            RoundWinTypeView(content: gameData.roundWinType)
                .position(x: width*0.8, y: height*0.11)
            TilesView(winnerID: gameData.roundWinnerID)
                .position(x: width*0.5, y: height*0.27)
            ForEach(Array(hands.enumerated()), id: \.offset) { index, hand in
                ScoreHanView(handName: hand.name, handHan: hand.han, delay: Double(index))
                .position(x: width*0.25, y: height*0.4 + 40*CGFloat(index))
            }
            Group {
                CustomText(content: "ドラ", size: 24, tracking: 0)
                    .foregroundColor(Colors.init().navy)
                    .position(x: width*0.62, y: height*0.4)
                ForEach(Array(gameData.doraTiles.enumerated()), id: \.offset) { index, tile in
                    Image(tile.name())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 60, alignment: .center)
                        .position(x: width*0.68 + 40*CGFloat(index), y: height*0.4)
                }
                if (userData.userID == gameData.roundWinnerID && gameData.myRiichiTurn != -1) || (gameData.opponentID == gameData.roundWinnerID && gameData.yourRiichiTurn != -1) {
                    CustomText(content: "裏ドラ", size: 24, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.62, y: height*0.52)
                    ForEach(Array(gameData.revDoraTiles.enumerated()), id: \.offset) { index, tile in
                        Image(tile.name())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 60, alignment: .center)
                            .position(x: width*0.68 + 40*CGFloat(index), y: height*0.52)
                    }
                }
            }
            Group {
                CustomText(content: scoreName, size: 36, tracking: 0)
                    .foregroundColor(Colors.init().navy)
                    .position(x: width*0.6, y: height*0.8)
                CustomText(content: "\(score)点", size: 36, tracking: 0)
                    .foregroundColor(Colors.init().navy)
                    .position(x: width*0.8, y: height*0.8)
            }
            if gameData.countdown <= 3 {
                CustomText(content: String(gameData.countdown), size: 20, tracking: 0)
                    .foregroundColor(Colors.init().navy)
                    .position(x: width*0.95, y: height*0.9)
            }
            if gameData.countdown <= 0 {
                ActionEmptyView(action: pop)
            }
            NavigationLink(
                destination: EndGameView(rootIsActive: self.$rootIsActive).navigationBarHidden(true),
                isActive: self.$showingEndGame
            ) { EmptyView() }
        }
        .onAppear { gameData.startTimer(initialCount: 3 + Int(ceil(Double(hands.count) * 0.5))) }
        .onDisappear { gameData.countdown = 100 }
    }
}

struct ScoreHanView: View {
    @EnvironmentObject var soundData: SoundData
    var handName: String
    var handHan: Int
    var delay: Double
    @State var isHidden: Bool = true
    
    func show() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay * 0.5) {
            withAnimation() {
                self.isHidden = false
                soundData.displayHandSound.play()
            }
        }
    }
    
    var body: some View {
        if isHidden {
            ActionEmptyView(action: show)
        }
        else {
            HStack {
                CustomText(content: handName, size: 24, tracking: 0)
                    .foregroundColor(Colors.init().navy)
                if handHan < 100 {
                    CustomText(content: "\(String(handHan))飜", size: 16, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                }
            }
            .transition(AnyTransition.slide.combined(with: AnyTransition.opacity))
            .onAppear() {
            }
        }
    }
}


struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ScoreView(
                rootIsActive: .constant(false),
                score: 12000,
                scoreName: "満貫",
                hands: [Hand(name: "立直", han: 1), Hand(name: "自摸", han: 1), Hand(name: "混一色", han: 3)]
            )
                .environmentObject(GameData())
                .environmentObject(UserData())
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

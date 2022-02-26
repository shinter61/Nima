//
//  ExhaustiveDrawView.swift
//  ExhaustiveDrawView
//
//  Created by 松本真太朗 on 2021/10/14.
//

import SwiftUI

struct ExhaustiveDrawView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @Environment(\.presentationMode) private var presentationMode
    @Binding var rootIsActive: Bool
    @State private var showingEndGame: Bool = false
    
    func pop() -> Void {
        if (gameData.isGameEnd) {
            gameService.socket.emit("EndGame", gameData.roomID)
            showingEndGame = true
        } else {
            if gameData.isParent {
                gameService.socket.emit("StartGame", gameData.roomID)
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                Group {
                    CustomText(content: "流局", size: 36, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.1, y: height*0.1)
                    NameView(name: "\(userData.userName)").position(x: width*0.2, y: height*0.25)
                    if gameData.myDrawWaits.count != 0 {
                        CustomText(content: "待ち牌：", size: 16, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                            .position(x: width*0.4, y: height*0.25)
                        HStack(alignment: .center, spacing: -6, content: {
                            ForEach(gameData.myDrawWaits, id: \.self) { tile in
                                Image(tile.name())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 60, alignment: .center)
                            }
                        })
                        .position(x: width*0.6, y: height*0.25)
                            
                    }
                    if gameData.myDrawWaits.count != 0 && gameData.yourWaits.count == 0 {
                        CustomText(content: "+1500", size: 24, tracking: 0)
                            .foregroundColor(Colors.init().green)
                            .position(x: width*0.85, y: height*0.25)
                    } else if gameData.myDrawWaits.count == 0 && gameData.yourWaits.count != 0 {
                        CustomText(content: "-1500", size: 24, tracking: 0)
                            .foregroundColor(Colors.init().red)
                            .position(x: width*0.85, y: height*0.25)
                    }
                    TilesView(winnerID: userData.userID)
                    .position(x: width*0.5, y: height*0.45)
                }
                Group {
                    NameView(name: "\(gameData.opponentName)").position(x: width*0.2, y: height*0.65)
                    if gameData.yourWaits.count != 0 {
                        CustomText(content: "待ち牌：", size: 16, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                            .position(x: width*0.4, y: height*0.65)
                        HStack(alignment: .center, spacing: -6, content: {
                            ForEach(gameData.yourWaits, id: \.self) { tile in
                                Image(tile.name())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 60, alignment: .center)
                            }
                        })
                        .position(x: width*0.6, y: height*0.65)
                    }
                    if gameData.yourWaits.count != 0 && gameData.myDrawWaits.count == 0 {
                        CustomText(content: "+1500", size: 24, tracking: 0)
                            .foregroundColor(Colors.init().green)
                            .position(x: width*0.85, y: height*0.65)
                    } else if gameData.yourWaits.count == 0 && gameData.myDrawWaits.count != 0 {
                        CustomText(content: "-1500", size: 24, tracking: 0)
                            .foregroundColor(Colors.init().red)
                            .position(x: width*0.85, y: height*0.65)
                    }
                    TilesView(winnerID: gameData.opponentID)
                    .position(x: width*0.5, y: height*0.85)
                }
                Group {
                    CustomText(content: String(gameData.countdown), size: 20, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.95, y: height*0.9)
                    if gameData.countdown <= 0 {
                        ActionEmptyView(action: pop)
                    }
                }
                NavigationLink(
                    destination: EndGameView(rootIsActive: self.$rootIsActive).navigationBarHidden(true),
                    isActive: self.$showingEndGame
                ) { EmptyView() }
            }
        }
        .onAppear { gameData.startTimer(initialCount: 3) }
        .onDisappear { gameData.countdown = 100 }
    }
}

struct ExhaustiveDrawView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ExhaustiveDrawView(rootIsActive: .constant(false))
                .environmentObject(GameData())
                .environmentObject(UserData())
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

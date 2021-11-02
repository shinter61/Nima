//
//  RegistPlayerNameView.swift
//  RegistPlayerNameView
//
//  Created by 松本真太朗 on 2021/11/02.
//

import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RegistPlayerNameView: View {
    @EnvironmentObject var gameData: GameData
    @State private var name: String = ""
    @State private var errorMessage: String = ""
    @State private var keyboardOpened: Bool = false
    @State private var showingMainMenu: Bool = false
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { UIApplication.shared.closeKeyboard() }
                CustomText(content: "プレイヤー名を入力してください", size: 24, tracking: 2)
                    .position(x: width/2, y: height*0.2)
                CustomText(content: "(2~8文字)", size: 16, tracking: 2)
                    .position(x: width/2, y: height*0.35)
                CustomText(content: errorMessage, size: 16, tracking: 2)
                    .foregroundColor(Colors.init().red)
                    .position(x: width/2, y: height*0.5)
                TextField("プレイヤー名を入力", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(width: width/2, height: 40, alignment: .center)
                    .position(x: width/2, y: height*0.7)
                
                if !keyboardOpened {
                    Button(action: {
                        if name.count < 2 || name.count > 8 {
                            errorMessage = "2~8文字以内で入力してください"
                            return
                        }
                        UserDefaults.standard.set(name, forKey: "playerID")
                        gameData.playerID = name
                        showingMainMenu = true
                    }) {
                        CustomText(content: "登録", size: 24, tracking: 2)
                    }
                    .position(x: width/2, y: height*0.85)
                }
            }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                keyboardOpened = true
            }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                keyboardOpened = false
            }
            
            NavigationLink(
                destination: MainMenu().navigationBarHidden(true),
                isActive: self.$showingMainMenu
            ) { EmptyView() }
        }
    }
}

struct RegistPlayerNameView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            RegistPlayerNameView()
                .environmentObject(GameData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

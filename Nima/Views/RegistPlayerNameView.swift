//
//  RegistPlayerNameView.swift
//  RegistPlayerNameView
//
//  Created by 松本真太朗 on 2021/11/02.
//

import SwiftUI
import KeychainAccess

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
    @State private var showingProgress: Bool = false
    
    func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    @available(iOS 15.0.0, *)
    func registUser() async {
        showingProgress = true
        
        if name.count < 2 || name.count > 8 {
            errorMessage = "2~8文字以内で入力してください"
            return
        }
        
        let newPassword = randomString(of: 16)
        do {
            let user: User = try await UserService().signUp(name: name, password: newPassword)
            UserDefaults.standard.set(user.id, forKey: "userID")
            let keychain = Keychain(service: "nima.password")
            keychain[String(user.id)] = newPassword
            showingProgress = false
            showingMainMenu = true
        } catch(let error) {
            showingProgress = false
            errorMessage = "登録失敗"
            debugPrint(error)
        }
    }
    
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
                    Button {
                        if #available(iOS 15.0, *) {
                            Task { await registUser() }
                        }
                    } label: {
                        CustomText(content: "登録", size: 24, tracking: 2)
                    }
                    .position(x: width/2, y: height*0.85)
                }
                
                
                if showingProgress {
                    Colors().lightGray.opacity(0.85).ignoresSafeArea(.all)
                    CustomText(content: "登録中", size: 28, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.5, y: height*0.3)
                    ProgressView()
                        .scaleEffect(x: 2, y: 2, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Colors().navy))
                        .position(x: width*0.5, y: height*0.7)
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

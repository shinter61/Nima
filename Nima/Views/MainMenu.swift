//
//  MainMenu.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI
import Alamofire
import KeychainAccess

struct MainMenu: View {
    @EnvironmentObject var userData: UserData
    @State private var showingMatching: Bool = false
    @State private var interstitial: Interstitial!
    
    @available(iOS 15.0.0, *)
    func loginUser() async {
        let keychain = Keychain(service: "nima.password")
        let userID = UserDefaults.standard.integer(forKey: "userID")
        do {
            let user: User = try await UserService().signIn(id: userID, password: keychain["\(String(userID))"]!)
            userData.userName = user.name
            userData.rating = user.rating
        } catch(let error) {
            debugPrint(error)
        }
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                ZStack {
                    Color.white.ignoresSafeArea(.all)
                    CustomText(content: "二麻", size: 48, tracking: 10)
                        .foregroundColor(Colors.init().navy)
                        .position(x: width*0.3, y: height*0.3)
                    VStack(alignment: .leading, spacing: 20) {
                        CustomText(content: "プレイヤー名: \(userData.userName)", size: 20, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                        CustomText(content: "レーティング: \(userData.rating)", size: 20, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                    }
                    .position(x: width*0.3, y: height*0.7)
                    
                    Button(action: {
                        showingMatching = true
                    }) {
                        CustomText(content: "対戦する", size: 24, tracking: 2)
                            .foregroundColor(Color.red)
                    }
                    .position(x: width*0.73, y: height*0.5)
                }
                
                NavigationLink(
                    destination: MatchingView(rootIsActive: self.$showingMatching).navigationBarHidden(true),
                    isActive: self.$showingMatching
                ) { EmptyView() }
            }
            .task { await loginUser() }
            .onAppear {
                interstitial?.showAd()
                interstitial = Interstitial()
            }
        }
    }
    
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MainMenu()
                .environmentObject(UserData())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

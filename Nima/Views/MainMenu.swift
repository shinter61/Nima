//
//  MainMenu.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI
import Alamofire
import KeychainAccess

struct SignIn: Encodable {
    let id: Int
    let password: String
}

struct MainMenu: View {
    @EnvironmentObject var userData: UserData
    @State private var showingMatching: Bool = false
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                Color.white.ignoresSafeArea(.all)
                VStack(alignment: .leading, spacing: 10) {
                    CustomText(content: "プレイヤー名: \(userData.playerID)", size: 20, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                    CustomText(content: "レーティング: \(userData.rating)", size: 20, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                }
                .position(x: width*0.17, y: height*0.15)
                CustomText(content: "二麻", size: 48, tracking: 10)
                    .foregroundColor(Colors.init().navy)
                    .position(x: width*0.5, y: height*0.2)
                
                Button(action: {
                    showingMatching = true
                }) {
                    CustomText(content: "対戦する", size: 24, tracking: 2)
                        .foregroundColor(Color.red)
                }
                .position(x: width*0.5, y: height*0.8)
            }
            
            NavigationLink(
                destination: MatchingView(rootIsActive: self.$showingMatching).navigationBarHidden(true),
                isActive: self.$showingMatching
            ) { EmptyView() }
        }
        .onAppear {
            let keychain = Keychain(service: "nima.password")
            let userID = UserDefaults.standard.integer(forKey: "userID")
            let signIn = SignIn(
                id: userID,
                password: keychain["\(String(userID))"]!
            )
            AF.request("http://localhost:3000/users/sign_in",
                       method: .post,
                       parameters: signIn,
                       encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let user):
                        debugPrint(user)
                        userData.playerID = user.name
                        userData.rating = user.rating
                    case .failure(let error):
                        print(error)
                    }
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

//
//  MainMenu.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI
import KeychainAccess
import AppTrackingTransparency
import GoogleMobileAds

struct MainMenu: View {
    @EnvironmentObject var userData: UserData
    @State private var showingMatching: Bool = false
    @State private var interstitial: Interstitial!
    @State private var trackingAuthorized: Bool?
    
    @available(iOS 15.0.0, *)
    func loginUser() async {
        let keychain = Keychain(service: "nima.password")
        let userID = UserDefaults.standard.integer(forKey: "userID")
        do {
            let user: User = try await UserService().signIn(id: userID, password: keychain["\(String(userID))"]!)
            DispatchQueue.main.async {
                userData.userName = user.name
                userData.rating = user.rating
            }
        } catch(let error) {
            debugPrint(error)
        }
    }
    
    func checkTrackingAuthorizationStatus() {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
            requestTrackingAuthorization()
        case .restricted:
            updateTrackingAuthorizationStatus(false)
        case .denied:
            updateTrackingAuthorizationStatus(false)
        case .authorized:
            updateTrackingAuthorizationStatus(true)
        @unknown default:
            fatalError()
        }
    }
    
    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined: break
            case .restricted:
                self.updateTrackingAuthorizationStatus(false)
            case .denied:
                self.updateTrackingAuthorizationStatus(false)
            case .authorized:
                self.updateTrackingAuthorizationStatus(true)
            @unknown default:
                fatalError()
            }
        }
    }
    
    func updateTrackingAuthorizationStatus(_ b: Bool) {
        GADMobileAds.sharedInstance().start { status in
            self.trackingAuthorized = b
        }
        interstitial?.showAd()
        interstitial = Interstitial()
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
                    
                    if userData.userName == "" {
                        Colors().lightGray.opacity(0.85).ignoresSafeArea(.all)
                        CustomText(content: "ログイン中", size: 28, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                            .position(x: width*0.5, y: height*0.3)
                        ProgressView()
                            .scaleEffect(x: 2, y: 2, anchor: .center)
                            .progressViewStyle(CircularProgressViewStyle(tint: Colors().navy))
                            .position(x: width*0.5, y: height*0.7)
                    }
                }
                
                NavigationLink(
                    destination: MatchingView(rootIsActive: self.$showingMatching).navigationBarHidden(true),
                    isActive: self.$showingMatching
                ) { EmptyView() }
            }
            .task { await loginUser() }
            .onAppear {
                checkTrackingAuthorizationStatus()
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

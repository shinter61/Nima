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
import SocketIO

struct MainMenu: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var gameService: GameService
    @State private var matchingStarted: Bool = false
    @State private var matchingFinished: Bool = false
    @State private var interstitial: Interstitial!
    @State private var trackingAuthorized: Bool?
    
    @State private var showingRule: Bool = false
    @State private var showingRecords: Bool = false
    @State private var showingRanking: Bool = false
    @State private var showingMyPage: Bool = false
    @State private var isAdTiming: Bool = true
    
    @State private var connectionsCount: Int = 0
    @State private var connectionsUpdateTimer: Timer!
    @State private var connectionsUpdateCountdown: Int = 10
    
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
        #if !DEBUG
            GADMobileAds.sharedInstance().start { status in
                self.trackingAuthorized = b
            }
            interstitial?.showAd()
            interstitial = Interstitial()
        #endif
    }
    
    func addHandler(socket: SocketIOClient!) -> Void {
        socket.on("CurrentConnectionsCount") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                connectionsCount = Int(dict["connectionsCount"]!)!
            }
        }
        socket.on("InformPlayersNames") { (data, ack) in
            if let dict = data[0] as? [String: String] {
                gameData.roomID = dict["roomID"]!
                if userData.userID == Int(dict["player1ID"]!) {
                    gameData.opponentID = Int(dict["player2ID"]!)!
                    gameData.opponentName = dict["player2Name"]!
                    gameData.opponentRating = Int(dict["player2Rating"]!)!
                    gameService.socket.emit("StartGame", gameData.roomID) // StartGameは2台につき1台からのみ発行
                } else if userData.userID == Int(dict["player2ID"]!) {
                    gameData.opponentID = Int(dict["player1ID"]!)!
                    gameData.opponentName = dict["player1Name"]!
                    gameData.opponentRating = Int(dict["player1Rating"]!)!
                }
                matchingStarted = false
                matchingFinished = true
            }
        }
    }
    
    func startUpdateConnectionsCountTimer() -> Void {
        var startTime: Date = Date()
        connectionsUpdateTimer?.invalidate()
        connectionsUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.second], from: startTime, to: current)).second!
            if diff >= 1 && diff < 2 { gameService.socket.emit("CurrentConnectionsCount") }
            if diff >= 10 { startTime = Date() }
            self.connectionsUpdateCountdown = 10 - diff
        })
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
                    
                    VStack {
                        HStack(alignment: .center, spacing: 28, content: {
                            if matchingStarted {
                                CustomText(content: "マッチング中...", size: 24, tracking: 2)
                                    .foregroundColor(Color.red)
                                ProgressView()
                                    .scaleEffect(x: 2, y: 2, anchor: .center)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                                Button(action: {
                                    gameData.allReset()
                                    isAdTiming = false
                                    matchingStarted = false
                                }) {
                                    Image(systemName: "multiply")
                                        .resizable()
                                        .frame(width: 28.0, height: 28.0, alignment: .center)
                                        .foregroundColor(Color.red)
                                }
                            } else {
                                Button(action: {
                                    isAdTiming = true
                                    matchingStarted = true
                                    gameService.socket.emit("StartMatching", userData.userID, userData.userName, userData.rating)
                                }) {
                                    CustomText(content: "対戦する", size: 24, tracking: 2)
                                        .foregroundColor(Color.red)
                                }
                            }
                        })
                        .padding(.bottom, 24)
                        CustomText(content: "接続数: \(connectionsCount)", size: 16, tracking: 0)
                            .foregroundColor(Colors.init().navy)
                    }
                    .position(x: width*0.73, y: height*0.5)
                    
                    HStack(alignment: .center, spacing: 36.0, content: {
                        Button(action: { showingRule = true }) {
                            Image(systemName: "book.closed")
                                .resizable()
                                .frame(width: 32.0, height: 32.0, alignment: .center)
                                .foregroundColor(Colors().navy)
                        }
                        .disabled(matchingStarted)
                        Button(action: { showingRecords = true }) {
                            Image(systemName: "folder")
                                .resizable()
                                .frame(width: 32.0, height: 32.0, alignment: .center)
                                .foregroundColor(Colors().navy)
                        }
                        .disabled(matchingStarted)
                        Button(action: { showingRanking = true }) {
                            Image(systemName: "crown")
                                .resizable()
                                .frame(width: 32.0, height: 28.0, alignment: .center)
                                .foregroundColor(Colors().navy)
                        }
                        .disabled(matchingStarted)
                        Button(action: { showingMyPage = true }) {
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 32.0, height: 32.0, alignment: .center)
                                .foregroundColor(Colors().navy)
                        }
                        .disabled(matchingStarted)
                    })
                    .position(x: width*0.73, y: height*0.9)
                    
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
                
                Group {
                    NavigationLink(
                        destination: GameView(rootIsActive: self.$matchingFinished).navigationBarHidden(true),
                        isActive: self.$matchingFinished
                    ) { EmptyView() }
                    
                    NavigationLink(
                        destination: RuleView(showingRule: self.$showingRule, isAdTiming: self.$isAdTiming).navigationBarHidden(true),
                        isActive: self.$showingRule
                    ) { EmptyView() }
                    
                    NavigationLink(
                        destination: RecordsView(showingRecords: self.$showingRecords, isAdTiming: self.$isAdTiming).navigationBarHidden(true),
                        isActive: self.$showingRecords
                    ) { EmptyView() }
                    
                    NavigationLink(
                        destination: RankingView(showingRanking: self.$showingRanking, isAdTiming: self.$isAdTiming).navigationBarHidden(true),
                        isActive: self.$showingRanking
                    ) { EmptyView() }
                    
                    NavigationLink(
                        destination: MyPageView(showingMyPage: self.$showingMyPage, isAdTiming: self.$isAdTiming).navigationBarHidden(true),
                        isActive: self.$showingMyPage
                    ) { EmptyView() }
                }
            }
            .task {
                await loginUser()
                if gameService.socket.handlers.count == 0 {
                    addHandler(socket: gameService.socket)
                }
                gameService.socket.connect(withPayload: ["name": userData.userName, "id": userData.userID])
                startUpdateConnectionsCountTimer()
            }
            .onAppear {
                if isAdTiming {
                    checkTrackingAuthorizationStatus()
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
                .environmentObject(GameService())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

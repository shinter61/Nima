//
//  GameService.swift
//  GameService
//
//  Created by 松本真太朗 on 2021/08/10.
//

import Foundation
import SocketIO

final class GameService: ObservableObject {
//    #if DEBUG
//        private var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
//    #else
        private var manager = SocketManager(socketURL: URL(string: "https://nima-server.herokuapp.com/")!, config: [.log(true), .compress])
//    #endif
    
    @Published var socket: SocketIOClient!
    
    init() {
        socket = manager.defaultSocket
    }
}

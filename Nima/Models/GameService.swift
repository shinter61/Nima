//
//  GameService.swift
//  GameService
//
//  Created by 松本真太朗 on 2021/08/10.
//

import Foundation
import SocketIO

final class GameService: ObservableObject {
//    private var manager = SocketManager(socketURL: URL(string: "https://hutarimajan.glitch.me/")!, config: [.log(true), .compress])
    private var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    
    @Published var socket: SocketIOClient!
    
    init() {
        socket = manager.defaultSocket
    }
}

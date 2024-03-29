//
//  SoundData.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/19.
//

import Foundation
import SwiftUI
import AVFoundation

final class SoundData: ObservableObject {
    @Published var riichiSound = try! AVAudioPlayer(data: NSDataAsset(name: "riichi")!.data)
    @Published var doubleRiichiSound = try! AVAudioPlayer(data: NSDataAsset(name: "double_riichi")!.data)
    @Published var discardSound = try! AVAudioPlayer(data: NSDataAsset(name: "discard")!.data)
    @Published var tsumoSound = try! AVAudioPlayer(data: NSDataAsset(name: "tsumo")!.data)
    @Published var ronSound = try! AVAudioPlayer(data: NSDataAsset(name: "ron")!.data)
    @Published var ponSound = try! AVAudioPlayer(data: NSDataAsset(name: "pon")!.data)
    @Published var kanSound = try! AVAudioPlayer(data: NSDataAsset(name: "kan")!.data)
    @Published var ripaiSound = try! AVAudioPlayer(data: NSDataAsset(name: "ripai")!.data)
    @Published var displayHandSound = try! AVAudioPlayer(data: NSDataAsset(name: "display_hand")!.data)
    @Published var displayScoreSound = try! AVAudioPlayer(data: NSDataAsset(name: "display_score")!.data)
}

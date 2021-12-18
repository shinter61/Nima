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
   @Published var discardSound = try! AVAudioPlayer(data: NSDataAsset(name: "discard")!.data)
}

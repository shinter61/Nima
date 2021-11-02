//
//  WinNoticeView.swift
//  WinNoticeView
//
//  Created by 松本真太朗 on 2021/11/02.
//

import SwiftUI

struct WinNoticeView: View {
    @Binding var showingWinNotice: Bool
    @Binding var showingScore: Bool
    @State private var countdown: Int = 2
    @State private var timer: Timer!
    
    var content: String
    
    func startTimer() -> Void {
        let startTime: Date = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.second], from: startTime, to: current)).second!
            if diff >= 2 { self.timer?.invalidate() }
            self.countdown = 2 - diff
        })
    }
    
    func pop() -> Void {
        showingWinNotice = false
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.init().red)
                .frame(width: 300, height: 120, alignment: .center)
            CustomText(content: content, size: 60, tracking: 10)
                .foregroundColor(Color.white)
            
            if countdown <= 0 {
                ActionEmptyView(action: pop)
            }
        }
        .onAppear { startTimer() }
        .onDisappear { showingScore = true }
    }
}

struct WinNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            WinNoticeView(showingWinNotice: .constant(false), showingScore: .constant(false), content: "ツモ")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

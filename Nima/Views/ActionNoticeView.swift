//
//  ActionNoticeView.swift
//  Nima
//
//  Created by 松本真太朗 on 2022/01/04.
//

import SwiftUI

struct ActionNoticeView: View {
    @Binding var showingActionNotice: Bool
    @State private var countdown: Int = 1
    @State private var timer: Timer!
    
    var showingActionContent: String
    
    func startTimer() -> Void {
        let startTime: Date = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ in
            let current = Date()
            let diff = (Calendar.current.dateComponents([.second], from: startTime, to: current)).second!
            if diff >= 1 { self.timer?.invalidate() }
            self.countdown = 1 - diff
        })
    }
    
    func pop() -> Void {
        showingActionNotice = false
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.init().navy)
                .frame(width: 300, height: 120, alignment: .center)
            CustomText(content: showingActionContent, size: 60, tracking: 10)
                .foregroundColor(Color.white)
            
            if countdown <= 0 {
                ActionEmptyView(action: pop)
            }
        }
        .onAppear { startTimer() }
    }
}

struct ActionNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ActionNoticeView(showingActionNotice: .constant(false), showingActionContent:  "立直")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

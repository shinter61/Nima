//
//  RecordsView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/17.
//

import SwiftUI

struct RecordsView: View {
    @Binding var showingRecords: Bool
    @Binding var isAdTiming: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            CustomText(content: "「牌譜」は実装予定です。", size: 24, tracking: 0)
                .position(x: width/2, y: height/2)
            
            Button(action: {
                isAdTiming = false
                showingRecords = false
            }) {
                CustomText(content: "戻る", size: 24, tracking: 0)
            }
            .position(x: width/2, y: height*0.8)
        }
    }
}

struct RecordsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsView(showingRecords: .constant(false), isAdTiming: .constant(false))
    }
}

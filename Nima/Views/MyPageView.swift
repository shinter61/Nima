//
//  MyPageView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/17.
//

import SwiftUI

struct MyPageView: View {
    @Binding var showingMyPage: Bool
    @Binding var isAdTiming: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            CustomText(content: "「マイページ」は実装予定です。", size: 24, tracking: 0)
                .position(x: width/2, y: height/2)
            
            Button(action: {
                isAdTiming = false
                showingMyPage = false
            }) {
                CustomText(content: "戻る", size: 24, tracking: 0)
            }
            .position(x: width/2, y: height*0.8)
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(showingMyPage: .constant(false), isAdTiming: .constant(false))
    }
}

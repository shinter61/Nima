//
//  RuleView.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/17.
//

import SwiftUI

struct RuleView: View {
    @Binding var showingRule: Bool
    @Binding var isAdTiming: Bool
    
    var body: some View {
        CustomText(content: "ルール", size: 32, tracking: 2)
        Button(action: {
            isAdTiming = false
            showingRule = false
        }) {
            CustomText(content: "戻る", size: 24, tracking: 0)
        }
    }
}

struct RuleView_Previews: PreviewProvider {
    static var previews: some View {
        RuleView(showingRule: .constant(false), isAdTiming: .constant(false))
    }
}

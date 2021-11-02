//
//  RoundWinTypeView.swift
//  RoundWinTypeView
//
//  Created by 松本真太朗 on 2021/11/02.
//

import SwiftUI

struct RoundWinTypeView: View {
    var content: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Colors.init().red)
                .frame(width: 80, height: 50, alignment: .center)
            CustomText(content: content, size: 32, tracking: 4)
                .foregroundColor(Color.white)
        }
    }
}

struct RoundWinTypeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            RoundWinTypeView(content: "ツモ")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

//
//  FuritenView.swift
//  FuritenView
//
//  Created by 松本真太朗 on 2021/10/16.
//

import SwiftUI

struct FuritenView: View {
    var body: some View {
        ZStack {
            let gradient = LinearGradient(colors: [Colors.init().red, Colors.init().lightGray], startPoint: .leading, endPoint: .trailing)
            RoundedRectangle(cornerRadius: 10)
                .fill(Colors.init().red)
                .frame(width: 60, height: 24, alignment: .center)
            CustomText(content: "振り聴", size: 16, tracking: 0)
                .foregroundColor(Colors.init().lightGray)
        }
    }
}

struct FuritenView_Previews: PreviewProvider {
    static var previews: some View {
        FuritenView()
    }
}

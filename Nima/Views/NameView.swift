//
//  NameView.swift
//  NameView
//
//  Created by 松本真太朗 on 2021/10/14.
//

import SwiftUI

struct NameView: View {
    var name: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Colors.init().navy)
                .frame(width: 140, height: 28, alignment: .center)
            RoundedRectangle(cornerRadius: 5)
                .fill(Colors.init().lightGray)
                .frame(width: 138, height: 26, alignment: .center)
            CustomText(content: name, size: 18, tracking: 0)
                .foregroundColor(Colors.init().navy)
        }
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView(name: "テスト名前テスト")
    }
}

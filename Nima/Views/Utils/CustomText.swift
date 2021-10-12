//
//  CustomText.swift
//  CustomText
//
//  Created by 松本真太朗 on 2021/09/26.
//

import SwiftUI

struct CustomText: View {
    var content: String
    var size: Int
    var tracking: Int
    
    var body: some View {
        Text(content)
            .font(.custom("NagomiGokubosoGothic-ExtraLight", size: CGFloat(size)))
            .tracking(CGFloat(tracking))
    }
}

struct CustomText_Previews: PreviewProvider {
    static var previews: some View {
        CustomText(content: "麻雀", size: 16, tracking: 0)
    }
}

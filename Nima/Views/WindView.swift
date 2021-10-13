//
//  WindView.swift
//  WindView
//
//  Created by 松本真太朗 on 2021/10/14.
//

import SwiftUI

struct WindView: View {
    var wind: String
    var body: some View {
        if wind == "東" {
            ZStack {
                Circle()
                    .fill(Colors.init().red)
                    .frame(width: 30, height: 30, alignment: .center)
                CustomText(content: wind, size: 16, tracking: 0)
                    .foregroundColor(Color.white)
            }
        } else {
            ZStack {
                Circle()
                    .fill(Colors.init().navy)
                    .frame(width: 30, height: 30, alignment: .center)
                CustomText(content: wind, size: 16, tracking: 0)
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        WindView(wind: "南")
    }
}

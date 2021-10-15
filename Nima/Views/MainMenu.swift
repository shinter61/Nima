//
//  MainMenu.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/08/08.
//

import SwiftUI

struct MainMenu: View {
    @State private var showingMatching: Bool = false
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                Color.white.ignoresSafeArea(.all)
                CustomText(content: "二麻", size: 48, tracking: 10)
                    .foregroundColor(Colors.init().navy)
                    .position(x: width*0.5, y: height*0.1)
                
                Button(action: {
                    showingMatching = true
                }) {
                    CustomText(content: "対戦する", size: 24, tracking: 2)
                        .foregroundColor(Color.red)
                }
                .position(x: width*0.5, y: height*0.7)
            }
            
            NavigationLink(
                destination: MatchingView(rootIsActive: self.$showingMatching).navigationBarHidden(true),
                isActive: self.$showingMatching
            ) { EmptyView() }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MainMenu()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

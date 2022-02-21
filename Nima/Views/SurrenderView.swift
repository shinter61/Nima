//
//  SurrenderView.swift
//  Nima
//
//  Created by 松本真太朗 on 2022/02/22.
//

import SwiftUI

struct SurrenderView: View {
    @Binding var showingSurrender: Bool
    
    func pop() -> Void {
        showingSurrender = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                Rectangle()
                    .fill(Colors().navy.opacity(0.7))
                    .frame(width: width*1.2, height: height*1.2, alignment: .center)
                    .onTapGesture { pop() }
                Rectangle()
                    .fill(Colors().navy)
                    .frame(width: width/2, height: height/2, alignment: .center)
                Rectangle()
                    .fill(Color.white)
                    .frame(width: width/2 - 4, height: height/2 - 4, alignment: .center)
                VStack {
                    CustomText(content: "本当に降参しますか？", size: 24, tracking: 0)
                        .foregroundColor(Colors.init().navy)
                        .padding(.top, 20)
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Colors().navy)
                                    .frame(width: 72, height: 32, alignment: .center)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .frame(width: 70, height: 30, alignment: .center)
                                CustomText(content: "はい", size: 24, tracking: 0)
                                    .foregroundColor(Colors().navy)
                            }
                        }
                        Spacer()
                        Button(action: { pop() }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Colors().navy)
                                    .frame(width: 72, height: 32, alignment: .center)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .frame(width: 70, height: 30, alignment: .center)
                                CustomText(content: "いいえ", size: 24, tracking: 0)
                                    .foregroundColor(Colors().navy)
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
                .frame(width: width/2 - 4, height: height/2 - 4, alignment: .center)
            }
            .position(x: width/2, y: height/2)
        }
    }
}

struct SurrenderView_Previews: PreviewProvider {
    static var previews: some View {
        SurrenderView(showingSurrender: .constant(true))
    }
}

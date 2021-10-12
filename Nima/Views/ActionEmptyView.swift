//
//  ActionEmptyView.swift
//  ActionEmptyView
//
//  Created by 松本真太朗 on 2021/08/23.
//

import SwiftUI

struct ActionEmptyView: View {
    var action: () -> Void
    var body: some View {
        VStack{ Text("hello") }.onAppear { action() }
    }
}

struct ActionEmptyView_Previews: PreviewProvider {
    static func printFunc() -> Void {
        print("hello")
    }
    static var previews: some View {
        ActionEmptyView(action: printFunc)
    }
}

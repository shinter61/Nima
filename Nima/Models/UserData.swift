//
//  UserData.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/06.
//

import Foundation
import SwiftUI

final class UserData: ObservableObject {
    @Published var userID: Int = UserDefaults.standard.integer(forKey: "userID")
    @Published var rating: Int = -1
    @Published var userName: String = ""
}

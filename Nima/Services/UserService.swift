//
//  UserService.swift
//  Nima
//
//  Created by 松本真太朗 on 2021/12/05.
//

import Foundation
import Alamofire

struct SignUp: Encodable {
    let name: String
    let password: String
}

struct SignIn: Encodable {
    let id: Int
    let password: String
}

final class UserService {
    @available(iOS 15.0.0, *)
    func signUp(name: String, password: String) async throws -> User {
        try await withUnsafeThrowingContinuation { continuation in
            let signUp = SignUp(name: name, password: password)
            AF.request("http://localhost:3000/users/sign_up",
                       method: .post,
                       parameters: signUp,
                       encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let user):
                        continuation.resume(returning: user)
                        return
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        return
                    }
                }
        }
    }
    
    @available(iOS 15.0.0, *)
    func signIn(id: Int, password: String) async throws -> User {
        try await withUnsafeThrowingContinuation { continuation in
            let signIn = SignIn(id: id, password: password)
            AF.request("http://localhost:3000/users/sign_in",
                       method: .post,
                       parameters: signIn,
                       encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let user):
                        continuation.resume(returning: user)
                        return
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        return
                    }
                }
        }
    }
}

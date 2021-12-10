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

struct UpdateRating: Encodable {
    let winnerID: Int
    let loserID: Int
}

struct RatingResponse: Decodable {
    let winnerID: Int
    let loserID: Int
    let winnerRating: Int
    let loserRating: Int
}

let baseURL = "http://localhost:3000"
//let baseURL = "https://nima-server.herokuapp.com"

final class UserService {
    @available(iOS 15.0.0, *)
    func signUp(name: String, password: String) async throws -> User {
        try await withUnsafeThrowingContinuation { continuation in
            let signUp = SignUp(name: name, password: password)
            AF.request("\(baseURL)/users/sign_up",
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
            AF.request("\(baseURL)/users/sign_in",
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
    
    @available(iOS 15.0.0, *)
    func updateRate(winnerID: Int, loserID: Int) async throws -> RatingResponse {
        try await withUnsafeThrowingContinuation { continuation in
            let updateRating = UpdateRating(winnerID: winnerID, loserID: loserID)
            AF.request("\(baseURL)/users/rating",
                       method: .put,
                       parameters: updateRating,
                       encoder: JSONParameterEncoder.default)
                .responseDecodable(of: RatingResponse.self) { response in
                    switch response.result {
                    case .success(let res):
                        continuation.resume(returning: res)
                        return
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        return
                    }
                }
        }
    }
}

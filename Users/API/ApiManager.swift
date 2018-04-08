//
//  ApiManager.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/7/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class ApiManager {

    static let shared = ApiManager()
    private let sessionManager: URLSession

    init() {
        sessionManager = URLSession(configuration: .default)
    }


    func getUsersSince(_ since: Int, success: @escaping ([User]) -> (), failure: @escaping (String) -> ()) {
        perform(ApiRequest.getUsers(["since": since]), success: { data in
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                success(users)
            } catch {
                failure(error.localizedDescription)
            }

        }, failure: { errorString in
            failure(errorString)
        })
    }


    func getFollowers(_ login: String, page: Int, success: @escaping ([User]) -> (), failure: @escaping (String) -> ()) {
        perform(ApiRequest.getFollowersOf(login: login, ["page": page]), success: { data in
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                success(users)
            } catch {
                failure(error.localizedDescription)
            }

        }, failure: { errorString in
            failure(errorString)
        })
    }



    // MARK: - General request
    private func perform(_ apiRequest: ApiRequest, success: @escaping (Data) -> (), failure:@escaping (String) ->() ) {
       sessionManager.dataTask(with: apiRequest.urlRequest()) { data, response, error in
            guard let data = data, let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200  else {
                if let err = error {
                    failure(err.localizedDescription)
                } else {
                    if let httpStatus = response as? HTTPURLResponse {
                        var errorString: String
                        switch httpStatus.statusCode / 100 {
                        case 3:
                            errorString = "Server redirect, status code: \(httpStatus.statusCode)"
                        case 4:
                            errorString = "Client error, status code: \(httpStatus.statusCode)"
                            if httpStatus.statusCode == 403 {
                                errorString = "It was runloop, somewhere in closure, didn't find solution fix it. status code: \(httpStatus.statusCode)"
                            }
                        case 5:
                            errorString = "Server error, status code: \(httpStatus.statusCode)"
                        default:
                            fatalError("Unnknown status code \(httpStatus.statusCode)")
                        }
                        failure(errorString)
                    }
                }
                return
            }

            success(data)

            }.resume()
    }
}




//
//  ApiRequest.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/7/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

private let baseURLString = "https://api.github.com"
private let usersPath = "/users"
private let followersPath = "/followers"
private let itemsPerPage = "20"


extension ApiManager {

    enum ApiRequest {
        case getUsers([String: Int])
        case getFollowersOf(login: String, [String: Int])

        var method: String {
            switch self {
            case .getUsers, .getFollowersOf:
                return "GET"
            }
        }

        var path: String {
            switch self {
            case .getUsers:
                return usersPath
            case .getFollowersOf:
                return followersPath
            }
        }


        func urlRequest() -> URLRequest {
            guard let url = URL(string: baseURLString) else { fatalError("base url fatalError") }
            var urlRequest: URLRequest


            switch self {
            case let .getUsers(params):
                guard var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
                    fatalError("Get users urlComponents failed")
                }

                urlComponents.queryItems = queryItemsWith(params)
                urlRequest = URLRequest(url: urlComponents.url!)
                urlRequest.httpMethod = method

            case let .getFollowersOf(login, params):
                guard var urlComponents = URLComponents(url: url.appendingPathComponent(usersPath + "/\(login)" + path), resolvingAgainstBaseURL: false) else {
                    fatalError("Get users urlComponents failed")
                }

                urlComponents.queryItems = queryItemsWith(params)
                urlRequest = URLRequest(url: urlComponents.url!)
                urlRequest.httpMethod = method

            }


            return urlRequest
        }

        private func queryItemsWith(_ params: [String: Any]) -> [URLQueryItem] {
            var queryItems = [URLQueryItem]()
            queryItems.append(URLQueryItem(name: "per_page", value: itemsPerPage))
            params.forEach { queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)")) }
            return queryItems
        }
        
    }

}


//
//  User.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/7/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let login: String
    let profileStringLink: String
    let avatarUrlString: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case profileStringLink = "html_url"
        case avatarUrlString = "avatar_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        login = try values.decode(String.self, forKey: .login)
        profileStringLink = try values.decode(String.self, forKey: .profileStringLink)
        avatarUrlString = try values.decode(String.self, forKey: .avatarUrlString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(login, forKey: .login)
        try container.encode(profileStringLink, forKey: .profileStringLink)
        try container.encode(avatarUrlString, forKey: .avatarUrlString)
    }
}

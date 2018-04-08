//
//  FollowersVM.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/8/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class FollowersVM {

    weak var view: (BaseViewProtocol & NavigationViewProtocol)!

    var followers = [User]()
    var userLogin: String!
    var followersPage = 1



    init(view: BaseViewProtocol & NavigationViewProtocol, login: String) {
        self.view = view
        self.userLogin = login

        loadUsers()
    }


    func loadUsers() {
        self.view.showProgress(completion: nil)

        ApiManager.shared.getFollowers(userLogin, page: followersPage, success: { [weak self] response in
            response.forEach { self?.followers.append($0) }
            self?.followersPage += 1
            self?.view.hideProgress {
                self?.view.updateData()
            }

        }) { [weak self] errorString in
            self?.view.hideProgress {
                self?.view.showAlert(errorString) {
                    self?.loadUsers()
                }
            }
        }
    }

    func didTapRowAt(_ index: Int) {
        self.view.openFollowers(followers[index].login)
    }
}

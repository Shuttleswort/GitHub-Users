//
//  UsersVM.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/7/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class UsersVM {

    var view: BaseViewProtocol & NavigationViewProtocol

    var users = [User]()

    var lastUser: Int {
        guard users.count > 0 else {
            return 0
        }
        return users.last!.id
    }

    enum UserMode {
        case generalList
        case followersList
    }


    init(view: BaseViewProtocol & NavigationViewProtocol) {
        self.view = view
        loadUsers()
    }


    func loadUsers() {
        self.view.showProgress(completion: nil)

        ApiManager.shared.getUsersSince(self.lastUser, success: { [weak self] response in
            response.forEach { self?.users.append($0) }
            self?.view.hideProgress {
                self?.view.updateData()
            }

            }) { [weak self] errorString in
                self?.view.hideProgress(completion: {
                    self?.view.showAlert(errorString) {
                        self?.loadUsers()
                    }
                })
        }
    }

    func didTapRowAt(_ index: Int) {
        self.view.openFollowers(users[index].login)
    }
}

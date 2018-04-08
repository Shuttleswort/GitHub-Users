//
//  UsersViewController.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/7/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

let cellIdentifier = "cell"

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: UsersVM!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "General list"
        viewModel = UsersVM(view: self)
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
    }

}

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError("can't create cell")
        }

        let user = viewModel.users[indexPath.row]

        cell.loginLabel.text = user.login
        cell.profileLink.text = user.profileStringLink
        cell.avatarImageView.downloadImageFromUrl(user.avatarUrlString)

        return cell
    }
}

extension UsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTapRowAt(indexPath.row)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (viewModel.users.count - indexPath.row) == 5 {
            viewModel.loadUsers()
        }
    }
}

extension UsersViewController: BaseViewProtocol {
    func updateData() {
        tableView.reloadData()
    }
}

extension UsersViewController: NavigationViewProtocol {
    func openFollowers(_ userLogin: String) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "followersVC") as? FollowersViewController else {
            fatalError("can't create FollowersViewController")
        }

        let viewModel = FollowersVM(view: controller, login: userLogin)
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
}







//
//  UIViewController+Extension.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/8/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

public typealias CompletionHandler = () -> Void


protocol BaseViewProtocol: class {
    func updateData()
    func showAlert(_ message: String, retryHandler: CompletionHandler?)
    func showProgress(completion:  (() -> Void)?)
    func hideProgress(completion: (() -> Void)?)

}

protocol NavigationViewProtocol: class {
    func openFollowers(_ userLogin: String)
}

fileprivate weak var _activityView: UIActivityIndicatorView?

extension UIViewController {

    var activityView: UIActivityIndicatorView {
        if let activityView = _activityView {
            return activityView
        }

        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = .black
        activityView.hidesWhenStopped = true
        activityView.center = view.center
        _activityView = activityView
        
        return activityView
    }




    func showAlert(_ message: String, retryHandler: CompletionHandler?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        if let retry = retryHandler {
            let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                retry()
            }
            alertController.addAction(retryAction)

        }

        alertController.addAction(cancelAction)


        self.present(alertController, animated: true, completion: nil)

    }

    func showProgress(completion:  (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let activity = self?.activityView else { return }
            self?.view.addSubview(activity)
            self?.activityView.startAnimating()
            completion?()
        }
    }

    func hideProgress(completion:  (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.stopAnimating()
            completion?()
        }
    }

}





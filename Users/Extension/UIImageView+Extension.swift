//
//  UIImageView+Extension.swift
//  Users
//
//  Created by Vladimir Abdrakhmanov on 4/7/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func downloadImageFromUrl(_ url: String, placeHolder: UIImage? = UIImage(named: "cat")) {
        guard let url = URL(string: url) else { return }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage

        } else {
            self.image = placeHolder
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    return
                }

                if imageCache.object(forKey: url.absoluteString as NSString) == nil {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }

                DispatchQueue.main.async {
                    self?.image = image
                }
            }).resume()
        }
    }
}



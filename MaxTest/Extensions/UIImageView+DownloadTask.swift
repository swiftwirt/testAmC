//
//  UIImageView+DownloadTask.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/27/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImageWithURL(url: URL, completionHandler: ((RequestRusult<Any>) -> ())? = nil) -> URLSessionDownloadTask
    {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) {
            [weak self] url, response, error in
            if error == nil, let url = url {
                performOnMainAsync {
                    if let strongSelf = self, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        strongSelf.image = image
                        completionHandler?(RequestRusult.success(image))
                    }
                }
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}

//
//  MTArticleCell.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class MTArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    fileprivate var dataTask: URLSessionDownloadTask?
    
    var article: Article! {
        didSet {
            if let link = article.imageMediumLink, let url = URL(string: link) {
                dataTask = articleImageView.loadImageWithURL(url: url)
                dataTask?.resume()
            }
            articleTitleLabel.text = article.title
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.image = nil
        articleTitleLabel.text = nil
        dataTask?.cancel()
    }
    
}

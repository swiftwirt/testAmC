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
    
    fileprivate let appManager = MTApplicationManager.instance()
    fileprivate var downloadTask: URLSessionDownloadTask?
    
    var article: Article! {
        didSet {
            articleTitleLabel.text = article.title
            uploadMediaContent(for: article)
        }
    }
    
    fileprivate func uploadMediaContent(for article: Article)
    {
        guard article.imageData == nil else {
            articleImageView.image = UIImage(data: article.imageData! as Data)
            return }
        
        var primeLink: String? { // Only nessesary image download
            return appManager.currentDevice ~= .phone ? article.imageThumbLink : article.imageMediumLink
        }
        
        if let link = primeLink, let url = URL(string: link) {
            downloadTask = appManager.apiService.networkingService.loadImageWithURL(url: url) { [weak self] image in
                article.imageData = UIImagePNGRepresentation(image) as NSData?
                self?.articleImageView.image = image
                self?.downloadTask?.resume()
                
                self?.appManager.apiService.updateEntity(article: article)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.image = nil
        articleTitleLabel.text = nil
        downloadTask?.cancel()
    }
    
    deinit {
        downloadTask?.cancel()
    }
    
}

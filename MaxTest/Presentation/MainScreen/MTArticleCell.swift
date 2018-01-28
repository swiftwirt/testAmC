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
            uploadDetails(for: article.articleID)
        }
    }
    
    fileprivate func uploadDetails(for articleID: Int64)
    {
        appManager.apiService.getArticleDetails(id: articleID) { [weak self] (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
         }
    }
    
    fileprivate func uploadMediaContent(for article: Article)
    {
        var hightPriorityLink: String? { //
            return appManager.currentDevice ~= .phone ? article.imageThumbLink : article.imageMediumLink
        }
        
        var lowPriorityLink: String? { //
            return appManager.currentDevice ~= .phone ? article.imageMediumLink : article.imageThumbLink
        }
        
        if let link = hightPriorityLink, let url = URL(string: link) {
            downloadTask = appManager.apiService.networkingService.loadImageWithURL(url: url) { [weak self] image in
                self?.articleImageView.image = image
                self?.downloadTask?.resume()
                
                self?.articleImageView.image = image
                
                if let link = lowPriorityLink, let url = URL(string: link) {
                    self?.downloadTask = self?.appManager.apiService.networkingService.loadImageWithURL(url: url) { [weak self] image in
                        
                        self?.downloadTask?.resume()
                    }
                }
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

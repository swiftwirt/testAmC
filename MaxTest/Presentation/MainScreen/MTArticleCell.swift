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
    
    var article: Article! {
        didSet {
            
        }
    }
    
}

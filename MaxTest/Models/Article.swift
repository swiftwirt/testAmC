//
//  Article.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

struct Article {
    
    enum JSONKey {
        static let id = "id"
        static let title = "title"
        static let imageMedium = "image_medium"
        static let imageThumb = "image_thumb"
        static let contentUrl = "content_url"
    }
    
    var id: Int!
    var title: String? = nil
    var imageMedium: String? = nil
    var imageThumb: String? = nil
    var contentUrl: String? = nil
    
    init?(with dictionary: [String: Any]?)
    {
        guard let dictionary = dictionary else { return nil }
        self.id = dictionary[JSONKey.id] as? Int
        self.title = dictionary[JSONKey.title] as? String
        self.imageMedium = dictionary[JSONKey.imageMedium] as? String
        self.imageThumb = dictionary[JSONKey.imageThumb] as? String
        self.contentUrl = dictionary[JSONKey.contentUrl] as? String
    }
    
}

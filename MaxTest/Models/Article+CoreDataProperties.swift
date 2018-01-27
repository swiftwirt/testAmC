//
//  Article+CoreDataProperties.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/27/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var articleID: Int64
    @NSManaged public var contentDetailsHTML: String?
    @NSManaged public var contentUrl: String?
    @NSManaged public var imageMedium: NSData?
    @NSManaged public var imageMediumLink: String?
    @NSManaged public var imageThumb: NSData?
    @NSManaged public var imageThumbLink: String?
    @NSManaged public var title: String?
    @NSManaged public var timeStamp: NSDate?

}

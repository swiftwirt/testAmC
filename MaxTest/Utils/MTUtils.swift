//
//  MTUtils.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

struct MTErrorMessage {
    
    // Networking module
    static let noJSONErrorDomain = "ErrorDomain: Can't get json dictionary!"
    static let badURLErrorDomain = "ErrorDomain: Can't get url from string!"
}

struct MTErrorCode {
    
    // Networking module
    static let noJSONError = -1111
    static let badURLError = -2222
}

struct CoreDataUtils {
    
    static let cacheName = "articles"
    static let defaultName = "Article"
    
    static let defaultSortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
}

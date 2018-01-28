//
//  ApplicationManager.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class MTApplicationManager {
    
    static func instance() -> MTApplicationManager {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationManager
    }
    
    var currentDevice: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    
    lazy var apiService: MTApiService = {
        return MTApiService()
    }()
    
    lazy var articleService: MTArticleService = {
        return MTArticleService(apiService: apiService)
    }()
    
}

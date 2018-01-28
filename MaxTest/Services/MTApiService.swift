//
//  ApiService.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class MTApiService {
    
    fileprivate(set) var networkingService = MTNetworkingService()
    fileprivate(set) var coreDataService = MTCoreDataService()
    
    // Networking
    
    func getArticles(completionHandler: @escaping (RequestRusult<Any>) -> ())
    {
        return networkingService.getArticles(completionHandler: completionHandler)
    }
    
    func getArticleDetails(id: Int64, completionHandler: @escaping (RequestRusult<Any>) -> ())
    {
        return networkingService.getArticleDetails(id: id, completionHandler: completionHandler)
    }
    
    func loadImageWithURL(url: URL, completionHandler: ((UIImage) -> ())? = nil) -> URLSessionDownloadTask
    {
        return networkingService.loadImageWithURL(url: url, completionHandler: completionHandler)
    }
    
    // Database
    
    func refreshDataBase(with array: [[String: Any]], completionHandler: @escaping () -> ())
    {
        coreDataService.refreshDataBase(with: array, completionHandler: completionHandler)
    }
}

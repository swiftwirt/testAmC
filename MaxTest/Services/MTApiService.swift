//
//  ApiService.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class MTApiService {
    
    fileprivate(set) var networkingService = MTNetworkingService()
    fileprivate(set) var coreDataService = MTCoreDataService()
    
    // Networking
    
    func getArticles(completionHandler: @escaping (RequestRusult<Any>) -> ())
    {
        return networkingService.getArticles(completionHandler: completionHandler)
    }
    
    // Database
    
    func refreshDataBase(with array: [[String: Any]], completionHandler: @escaping () -> ())
    {
        coreDataService.refreshDataBase(with: array, completionHandler: completionHandler)
    }
}

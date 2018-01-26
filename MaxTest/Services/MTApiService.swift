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
    
    func getArticles(completionHandler: @escaping (RequestRusult<Any>) -> ())
    {
        return networkingService.getArticles(completionHandler: completionHandler)
    }
    
}

//
//  MTArticleService.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/28/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class  MTArticleService {
    
    fileprivate let apiService: MTApiService!
    
    init(apiService: MTApiService) {
        self.apiService = apiService
    }
    
    func uploadArticles(completionHandler: (() -> ())? = nil)
    {
        apiService.getArticles { [unowned self] (result) in
            switch result {
            case .success(let data):
                if let jsonArray = MTParser.parseJSON(data: data as! Data) {
                    self.apiService.refreshDataBase(with: jsonArray) {
                        completionHandler?()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

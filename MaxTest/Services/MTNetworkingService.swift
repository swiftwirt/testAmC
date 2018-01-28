//
//  NetworkingServicee.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

enum RequestRusult<T> {
    
    case success(Any)
    case failure(Error)
}

class MTNetworkingService {
    
    enum EndPoint {
        static let baseLink = "http://madiosgames.com/"
        static let apiSpecs = "api/v1/"
        static let application = "application/"
        static let iosTest = "ios_test_task/"
        static let articles = "articles"
        
        static var articlesBasicLink: String {
            return EndPoint.baseLink + EndPoint.apiSpecs + EndPoint.application + EndPoint.iosTest + EndPoint.articles
        }
        
        static var articlesDetailsBasicLink: String {
            return EndPoint.baseLink + EndPoint.apiSpecs
        }
    }
    
    private var dataTask: URLSessionDataTask? = nil
    private var badURLError: NSError {
        return NSError(domain: MTErrorMessage.badURLErrorDomain, code: MTErrorCode.badURLError, userInfo: nil)
    }

    func getArticles(completionHandler: @escaping (RequestRusult<Any>) -> ())
    {
        guard let url = URL(string: EndPoint.articlesBasicLink) else {
            completionHandler(RequestRusult.failure(badURLError))
            return
        }
        
        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func getArticleDetails(id: Int64, completionHandler: @escaping (RequestRusult<Any>) -> ())
    {
        guard let url = URL(string: EndPoint.articlesDetailsBasicLink + String(id)) else {
            completionHandler(RequestRusult.failure(badURLError))
            return
        }

        performRequest(with: url, completionHandler: completionHandler)
    }
    
    func loadImageWithURL(url: URL, completionHandler: ((UIImage) -> ())? = nil) -> URLSessionDownloadTask
    {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { url, response, error in
            if error == nil, let url = url {
                performOnMainAsync {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        completionHandler?((image))
                    }
                }
            }
        }
        downloadTask.resume()
        return downloadTask
    }
    
    private func performRequest(with url: URL, completionHandler: @escaping (RequestRusult<Any>) -> ())
    {
        dataTask?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let session = URLSession.shared
        
        dataTask = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            if let error = error {
                completionHandler(RequestRusult.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data {
                
                completionHandler(RequestRusult.success(data))
            } else {
                let error = NSError(domain: MTErrorMessage.noJSONErrorDomain, code: MTErrorCode.noJSONError, userInfo: nil)
                completionHandler(RequestRusult.failure(error))
            }
            
            performOnMainAsync {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
        dataTask?.resume()
    }
}

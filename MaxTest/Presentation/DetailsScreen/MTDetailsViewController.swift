//
//  MTDetailsViewController.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/28/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import WebKit

class MTDetailsViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var htmlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleDetailsContent()
    }
    
    fileprivate func handleDetailsContent()
    {
        guard htmlString != nil else { return }
        webView.loadHTMLString(htmlString!, baseURL: nil)
        UIView.animate(withDuration: AnimationDuratiion.defaultFade) { [weak self] in
            self?.webView.alpha = 1.0
        }
    }

}

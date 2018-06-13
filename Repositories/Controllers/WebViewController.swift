//
//  WebViewController.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.load(URLRequest(url: URL(string: "https://github.com/pennersr/django-allauth")!))
        }
    }
}

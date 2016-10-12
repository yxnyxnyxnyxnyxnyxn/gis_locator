//
//  ThirdViewController.swift
//  BuildPayDemo
//
//  Created by Mark Bofill on 9/23/16.
//  Copyright © 2016 Mark Bofill. All rights reserved.
//

//
//  ThirdViewController.swift
//  BuildPayDemo
//
//  Created by Mark Bofill on 9/21/16.
//  Copyright © 2016 Mark Bofill. All rights reserved.
//
import Foundation
import UIKit
import WebKit

class ThirdViewController: UIViewController, UIWebViewDelegate  {

    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let url = NSURL(string: "https://test-webapp.gobuildpay.com")
        let urlRequest = NSURLRequest(URL: url!)
        webView.loadRequest(urlRequest)
        
       }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


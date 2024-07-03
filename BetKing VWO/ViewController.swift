//
//  ViewController.swift
//  BetKing VWO
//
//  Created by Bryan Caro on 2/7/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .green
        
        // Crear WKWebView
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // Cargar URL
        if let url = URL(string: "https://www.as.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// Extensión para conformar al protocolo WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView finished loading")
    }
}

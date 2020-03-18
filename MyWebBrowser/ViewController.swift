//
//  ViewController.swift
//  MyWebBrowser
//
//  Created by 홍정표 on 2020/03/02.
//  Copyright © 2020 홍정표. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    //mark: -property
    
    //mark: -IBoutlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //mark: -method
    //mark: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webView.navigationDelegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let firstPageURL: URL?
        
        if let lastURL: URL = UserDefaults.standard.url(forKey: lastPageURLDefaultKey){
            firstPageURL = lastURL
        }else{
            firstPageURL = URL(string: "https://www.google.com")
        }
        
        guard let pageURL: URL = firstPageURL else{
            return
        }
        let urlRequest: URLRequest = URLRequest(url: pageURL)
        self.webView.load(urlRequest)
    }
    //mark: -IBAction
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    @IBAction func reFresh(_ sender: UIBarButtonItem) {
        self.webView.reload()
    }
    
    @IBAction func fastForward(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    //mark: Custom method
    func showNetworkingIndicator(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    func hideNetworkingIndicator(){
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}
extension ViewController:WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish navigation")
        
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.lastPageURL = webView.url
        }
        webView.evaluateJavaScript("document title") { (value: Any?,error: Error?) in
            if let error: Error = error{
                print(error.localizedDescription)
                return
            }
            guard let title: String = value as? String else {
                return
            }
            
            self.navigationItem.title = title
        }
        self.hideNetworkingIndicator()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error ){
        print("did fail navigation")
        print("\(error.localizedDescription)")
        
        self.hideNetworkingIndicator()
        let message: String = "오류발생!\n" + error.localizedDescription
        
        let alert: UIAlertController
        alert = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        let okayAction: UIAlertAction
        okayAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(okayAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func webView(_ webView:WKWebView, didStartProvisionalNavigation navigation:WKNavigation!) {
        print("did start navigation")
        self.showNetworkingIndicator()
    }
    
}


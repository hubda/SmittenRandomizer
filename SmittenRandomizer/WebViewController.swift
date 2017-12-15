//
//  WebViewController.swift
//  SmittenRandomizer
//
//  Created by Daniel Huber on 12/13/17.
//  Copyright © 2017 Daniel Huber. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,  UIWebViewDelegate {
    //MARK: Properties
    @IBOutlet weak var webView: UIWebView!
    var url: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let link = URL(string: url)
        let urlRequest = URLRequest(url: link!)
        print("request: \(urlRequest)")
        webView.loadRequest(urlRequest)
        //webView.loadRequest(URLRequest(url: URL(string: url)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

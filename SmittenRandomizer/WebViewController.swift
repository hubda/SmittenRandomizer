//
//  WebViewController.swift
//  SmittenRandomizer
//
//  Created by Daniel Huber on 12/13/17.
//  Copyright © 2017 Daniel Huber. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var webView: UIWebView!
    var url: NSURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if url != "" {
        webView.load(<#T##data: Data##Data#>, mimeType: <#T##String#>, textEncodingName: <#T##String#>, baseURL: url)
        }
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

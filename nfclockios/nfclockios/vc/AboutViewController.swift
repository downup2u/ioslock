//
//  AboutViewController.swift
//  nfclockios
//
//  Created by wxqdev on 15/6/10.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
   @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        webView?.opaque = false
        webView?.backgroundColor = UIColor.clearColor()
        if let path = NSBundle.mainBundle().pathForResource("about", ofType: "html",inDirectory:"www") {
                let baseURL = NSURL.fileURLWithPath(path.stringByDeletingLastPathComponent,isDirectory:true)
                let requestURL = NSURL(string:path.lastPathComponent,relativeToURL:baseURL)
                let request = NSURLRequest(URL: requestURL!)
                webView.loadRequest(request)
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

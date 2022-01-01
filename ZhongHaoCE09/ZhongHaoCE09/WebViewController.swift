//
//  WebViewController.swift
//  ZhongHaoCE09
//
//  Created by Hao Zhong on 8/1/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var newsBrowser: WKWebView!
    
    var enterURL: URL? = nil
    var source = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = source
        
        if let url = enterURL {
            newsBrowser.load(URLRequest(url: url))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

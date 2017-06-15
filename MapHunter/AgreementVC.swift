//
//  AgreementVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class AgreementVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "使用条款和隐私政策"
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = URL(string: "http://www.baidu.com"){
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    //MARK:-返回
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}

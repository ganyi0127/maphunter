//
//  SexVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/3/30.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class SexVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let data = ["男", "女"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = timeColor
        
        let tableview = UITableView(frame: view.frame, style: .grouped)
        tableview.isScrollEnabled = false
        tableview.delegate = self
        tableview.dataSource = self
        view.addSubview(tableview)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = navigationController?.popViewController(animated: true)
    }
}

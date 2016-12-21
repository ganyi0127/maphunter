//
//  MeUnit.swift
//  MapHunter
//
//  Created by YiGan on 21/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class MeUnit: UITableViewController {
    init(){
        super.init(style: .grouped)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
}

//MARK:- tableview
extension MeUnit{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "公制"
            cell.accessoryType = .checkmark
        case 1:
            cell.textLabel?.text = "英制"
            cell.accessoryType = .none
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = navigationController?.popViewController(animated: true)
    }
}

//
//  MeInfo.swift
//  MapHunter
//
//  Created by YiGan on 20/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class MeInfo: UITableViewController {
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var careerLabel: UILabel!
    @IBOutlet weak var activityStrengthLabel: UILabel!
    
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func config(){
        headImageView.layer.cornerRadius = 20
    }
    
    private func createContents(){
        let itemButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(save(sender:)))
        navigationItem.rightBarButtonItem = itemButton
    }
    
    @objc private func save(sender: UIBarButtonItem){
        debugPrint("save")
    }
}

//MARK:- tableview
extension MeInfo{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 1
        }
        return 22
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //设置分割线
        cell.separatorInset = .zero
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)){
            cell.layoutMargins = .zero
        }
        
        if cell.responds(to: #selector(setter: UITableViewCell.preservesSuperviewLayoutMargins)){
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0{
                let headViewController = HeadViewController(image: headImageView.image)
                navigationController?.pushViewController(headViewController, animated: true)
            }
        }
    }
}

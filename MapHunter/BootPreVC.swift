//
//  BootPreVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/12.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class BootPreVC: UIViewController {
    
    @IBOutlet weak var bandTypeLabel: UILabel!
    @IBOutlet weak var bandDetailLabel: UILabel!
    @IBOutlet weak var bandImageView: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var filterName: String?     //设备名
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if let name = filterName{            
            bandTypeLabel.text = "激活您的" + name.uppercased()
            bandDetailLabel.text = "请将手环配套的USB线相连，然后将线缆插入通电的USB接口来激活手环"
            if let image = UIImage(named: "resource/scan/\(name)_back"){
                bandImageView.image = image
            }
        }
    }
    
    private func config(){
        
        //设置标签字体
        bandTypeLabel.font = fontMiddle
        bandDetailLabel.font = fontSmall
        
        //设置下一步颜色
        nextButton.setTitleColor(defaut_color, for: .normal)
        
        //设置返回图片
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 返回上级页面
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到下级页面
    @IBAction func next(_ sender: UIButton) {
        
        //跳转到搜索页 过滤
        let appointScanVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "scan") as! AppointScanVC
        appointScanVC.filterName = filterName
        navigationController?.show(appointScanVC, sender: nil)
    }
}

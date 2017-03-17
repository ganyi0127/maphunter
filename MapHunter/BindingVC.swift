//
//  BindingVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/2/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
class BindingVC: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bandImageview: UIImageView!
    @IBOutlet weak var unbindingButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var synchroDateLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- 功能列表
    fileprivate var funcTable: FuncTable?{
        didSet{
            guard let ft = funcTable else {
                return
            }
            debugPrint(ft)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        navigationController?.setNavigation(hidden: false)
        
        //背景色
        topView.backgroundColor = .white
        view.backgroundColor = timeColor
        
        //按钮
        unbindingButton.setTitle("解绑", for: .normal)
        unbindingButton.setTitleColor(subWordColor, for: .normal)
        if let image = UIImage(named: "resource/scan/unbund"){
            unbindingButton.setBackgroundImage(image, for: .normal)
        }
        
        //标签
        nameLabel.textColor = wordColor
        nameLabel.font = fontMiddle
        nameLabel.text = "~"
        synchroDateLabel.textColor = subWordColor
        synchroDateLabel.font = fontSmall
        synchroDateLabel.text = "上次同步时间: ~"
        versionLabel.textColor = subWordColor
        versionLabel.font = fontSmall
        versionLabel.text = "固件版本: ~"
        energyLabel.textColor = subWordColor
        energyLabel.font = fontSmall
        energyLabel.text = "电池容量: ~"
        
        //注册functable cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "custom")
        collectionView.backgroundColor = .clear
//        collectionView.collectionViewLayout = UICollectionViewLayout()
    }
    
    private func createContents(){
        
        //获取设备名称
        let name = PeripheralManager.share().currentPeripheral?.name
        nameLabel.text = name
        
        //更新图片
        if let bandName = name  {
            var imageName: String
            if bandName.contains("100") || bandName.contains("102"){
                imageName = "resource/scan/id100_102"
            }else if bandName.contains("101"){
                imageName = "resource/scan/id101"
            }else if bandName.contains("107"){
                imageName = "resource/scan/id107"
            }else if bandName.contains("115"){
                imageName = "resource/scan/id115"
            }else if bandName.contains("119"){
                imageName = "resource/scan/id119"
            }else{
                imageName = "resource/scan/undefined"
            }
            if let image = UIImage(named: imageName){
                bandImageview.image = image
            }
        }
        
        beginLoading()
        
        //获取设备信息
        let angelManager = AngelManager.share()
        angelManager?.getDevice{
            device in
            self.endLoading()
            
            guard let existDevice = device else{
                return
            }
            
            DispatchQueue.main.async {
                var dateStr = "~"
                if let date = existDevice.synDate{
                    //获取日期格式
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyy-MM-dd hh:mm"
                    dateStr = formatter.string(from: date as Date)
                }
                self.synchroDateLabel.text = "上次同步时间: " + dateStr
                self.versionLabel.text = "固件版本: v\(existDevice.version)"
                self.energyLabel.text = "电池容量: \(existDevice.battLevel)%"
                self.funcTable = existDevice.funcTable
            }
        }
    }
    
    @IBAction func unbinding(_ sender: UIButton) {
        
        if let peripheral = PeripheralManager.share().currentPeripheral {
            
            GodManager.share().disconnect(peripheral){
                success in
                if success{
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

//MARK:- collectionView delegate
extension BindingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "custom"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        let cell = FunctableCell(functableType: .camera)
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (view_size.width - 0) / 3
        return CGSize(width: length, height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view_size.width, height: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
//        
//    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

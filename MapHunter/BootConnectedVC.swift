//
//  BootUnconnectVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/12.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
class BootConnectedVC: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var effectImageView: UIImageView!
    @IBOutlet weak var bandImageView: UIImageView!
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //手环名称
    var bandName: String? {
        didSet{
            let name = bandName?.lowercased().replacingOccurrences(of: " ", with: "")
            
            if name == "id107plus" || name == "id107plushr"{
                bandIdType = .id107plus
            }else if name == "id119"{
                bandIdType = .id119
            }else if name == "id127"{
                bandIdType = .id127
            }else if name == "id129"{
                bandIdType = .id129
            }else{
                bandIdType = .undefined
            }
        }
    }
    
    //MARK:- id型号
    private var bandIdType: BandIdType?{
        didSet{
            
            guard let type = bandIdType else {
                return
            }
            
            var imageName: String
            switch type {
            case .id107plus:
                imageName = "resource/scan/id107plus"
            case .id119:
                imageName = "resource/scan/id119"
            case .id127:
                imageName = "resource/scan/id127"
            case .id129:
                imageName = "resource/scan/id129"
            default:
                imageName = "resource/scan/undefined"
            }
            bandImageName = imageName
        }
    }
    
    //MARK:- 图片名
    private var bandImageName: String?
    
    //是否成功 
    var isSuccess: Bool?
    
    //MARK:- init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = bandImageName {
            if let image = UIImage(named: name) {
                bandImageView.image = image
            }
        }
        
        
        if let flag = isSuccess{
            if flag{
                nextButton.setTitle("下一步", for: .normal)
                firstLabel.text = "绑定成功"
                secondLabel.text = "现在进行个性化设置"  //"确保" + name + "位于您的附近，然后重试"
            }else{
                nextButton.setTitle("请再试一次", for: .normal)
                firstLabel.text = "绑定失败"
                secondLabel.text = "请确保打开您的手环，并贴近手机"
            }
        }else{
            firstLabel.text = "无法配对"
            let name = bandName == nil ? "手环" : bandName!
            secondLabel.text = "确保" + name + "位于您的附近，然后重试"
        }
        
        warningImageView.isHidden = isSuccess ?? false
        
        if let success = isSuccess{
            if success {
                effectImageView.isHidden = false
                //添加特效动画
                let rotaAnim = CABasicAnimation(keyPath: "transform.rotation.z")
                rotaAnim.fromValue = 0
                rotaAnim.toValue = Double.pi * 2
                rotaAnim.fillMode = kCAFillModeBoth
                rotaAnim.repeatCount = HUGE
                rotaAnim.duration = 3
                effectImageView.layer.add(rotaAnim, forKey: nil)
            }
        }
    }
    
    private func config(){
        //设置标签字体
        firstLabel.font = fontMiddle
        secondLabel.font = fontSmall
        
        //设置下一步颜色
        nextButton.setTitleColor(defaut_color, for: .normal)
        
        //设置返回图片
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    //MARK:- 返回上两级页面
    @IBAction func back(_ sender: UIButton) {
        
        if let success = isSuccess{
            if success{
                if let peripheral = PeripheralManager.share().currentPeripheral {
                    
                    if peripheral.state == .connected{
                        GodManager.share().disconnect(peripheral){
                            success in
                            if success{
                                self.popEarlierVC()
                            }
                        }
                    }else{
                        let uuidstr = peripheral.identifier.uuidString
                        _ = PeripheralManager.share().delete(UUIDString: uuidstr)
                        PeripheralManager.share().UUID = nil
                        self.popEarlierVC()
                    }
                }else{
                    let list = PeripheralManager.share().selectUUIDStringList()
                    list.forEach{
                        uuidStr in
                        _ = PeripheralManager.share().delete(UUIDString: uuidStr)
                    }
                    self.popEarlierVC()
                }
                return
            }
        }
        popEarlierVC()
    }
    
    //MARK:- 返回上两级页面
    private func popEarlierVC(){
        let viewcontrollers = navigationController?.viewControllers
        guard let count = viewcontrollers?.count, count >= 3 else{
            return
        }
        
        guard let vc = viewcontrollers?[count - 3] else {
            return
        }
        _ = navigationController?.popToViewController(vc, animated: true)
    }
    
    //MARK:- 返回上一级页面
    @IBAction func tryAgain(_ sender: UIButton) {        
        if nextButton.titleLabel?.text == "下一步" {
            
            //推送到个人设置页
            if let infoVC = UIStoryboard(name: "Info", bundle: Bundle.main).instantiateViewController(withIdentifier: "infovc") as? InfoVC {
                navigationController?.show(infoVC, sender: nil)
            }
        }else{
            nextButton.isEnabled = false
            beginLoading(byTitle: "正在设置手环")
            let angelManager = AngelManager.share()
            angelManager?.setBind(true){
                success in
                self.endLoading()
                self.nextButton.isEnabled = true
                //跳转到绑定成功页面
                if success{
                    //跳转到主页
                    let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
                    self.present(rootTBC, animated: true, completion: nil)
                }else{
                    
                }
            }
        }
    }
}

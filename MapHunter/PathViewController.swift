//
//  PathViewController.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class PathViewController: FunOriginViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    private lazy var originTypeviewFrame: CGRect = {
       return self.typeView.frame
    }()
    @IBOutlet weak var settingView: UIView!
    
    override var isOpen: Bool{
        didSet{
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                
                var y: CGFloat
                if self.isOpen {
                    y = self.originTypeviewFrame.origin.y + 64
                }else{
                    y = self.originTypeviewFrame.origin.y
                }
                self.typeView.frame.origin.y = y
                self.settingButton.frame.origin.y = y
                self.settingView.frame.origin.y = y + self.originTypeviewFrame.height
                
            }, completion: {
                complete in
            })
        }
    }
    
    //类型子按钮
    private lazy var walkingTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeLabel.frame)
        button.titleLabel?.font = fontSmall
        button.setTitleColor(.gray, for: .normal)
        button.isHidden = true
        button.setTitle("步行", for: .normal)
        return button
    }()
    private lazy var hikingTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeLabel.frame)
        button.titleLabel?.font = fontSmall
        button.setTitleColor(.gray, for: .normal)
        button.isHidden = true
        button.setTitle("徒步", for: .normal)
        return button
    }()
    private lazy var runningTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeLabel.frame)
        button.titleLabel?.font = fontSmall
        button.setTitleColor(.gray, for: .normal)
        button.isHidden = true
        button.setTitle("跑步", for: .normal)
        return button
    }()
    private lazy var ridingTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeLabel.frame)
        button.titleLabel?.font = fontSmall
        button.setTitleColor(.gray, for: .normal)
        button.isHidden = true
        button.setTitle("骑行", for: .normal)
        return button
    }()
    //存储所有标签
    private lazy var typebuttonList: [UIButton] = {
       return [self.walkingTypebutton, self.hikingTypebutton, self.runningTypebutton, self.ridingTypebutton]
    }()
    
    private enum ShowType{
        case type
        case setting
    }
    private var showType: ShowType?{
        didSet{
            guard let st = showType else {
                //所有按钮复原
                setTypeStatus(flag: false)
                setSettingStatus(flag: false)
                return
            }
            switch st {
            case .type:
                //展开类型按钮
                setTypeStatus(flag: true)
                setSettingStatus(flag: false)
            case .setting:
                //展开设置按钮
                setTypeStatus(flag: false)
                setSettingStatus(flag: true)
            }
        }
    }
    
    //设置类型按钮状态
    private func setTypeStatus(flag: Bool){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            if flag{
                //展开
                self.typeView.frame = CGRect(x: self.typeView.frame.origin.x, y: self.typeView.frame.origin.y, width: self.typeView.frame.width, height: self.originTypeviewFrame.height * 5)
                self.typebuttonList.enumerated().forEach(){
                    index, button in
                    button.isHidden = false
                    button.frame.origin.y = self.originTypeviewFrame.height * CGFloat(index + 1)
                }
            }else{
                //关闭
                self.typeView.frame = CGRect(x: self.typeView.frame.origin.x, y: self.typeView.frame.origin.y, width: self.typeView.frame.width, height: self.originTypeviewFrame.height)
                self.typebuttonList.forEach(){
                    button in
                    button.isHidden = true
                    button.frame.origin.y = 0
                }
            }
        }, completion: {
            complete in
        })
    }
    
    //设置按钮状态
    private func setSettingStatus(flag: Bool){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            var img: UIImage?
            if flag{
                //展开
                img = UIImage(named: "resource/map/setting_1")
                self.settingView.isHidden = false
            }else{
                //关闭
                img = UIImage(named: "resource/map/setting_0")
                self.settingView.isHidden = true
            }
            self.settingButton.setImage(img, for: .normal)
        }, completion: {
            complete in
        })
    }
    
    //类型点击
    private var tap: UITapGestureRecognizer?
    
    //MARK:- init
    override func config() {
        super.config()
        
        customTitle = "轨迹"
        
        //添加点击事件
        let typeTap = UITapGestureRecognizer(target: typeLabel, action: #selector(typeClicked))
        typeTap.numberOfTapsRequired = 1
        typeTap.numberOfTouchesRequired = 1
        typeLabel.addGestureRecognizer(typeTap)
    }
    
    override func createContents() {
        //添加背景图片
        let backgroundImage = UIImage(named: "resource/map/background/path")?.transfromImage(size: view_size)
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = CGRect(origin: .zero, size: view_size)
        backgroundImageView.layer.cornerRadius = 20
        view.insertSubview(backgroundImageView, at: 0)
        
        super.createContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        typeView.layer.cornerRadius = originTypeviewFrame.height / 2
        
        //添加类型按钮
        typeView.insertSubview(walkingTypebutton, belowSubview: typeLabel)
        typeView.insertSubview(hikingTypebutton, belowSubview: typeLabel)
        typeView.insertSubview(runningTypebutton, belowSubview: typeLabel)
        typeView.insertSubview(ridingTypebutton, belowSubview: typeLabel)
    }
    
    deinit {
        if let t = tap {
            view.removeGestureRecognizer(t)
        }
    }
    
    override func click(location: CGPoint, open: Bool) {
        
        let node = view.hitTest(location, with: nil)
        if node == startButton {
            start(startButton)      //点击开始
        }else if node == settingButton{
            settingClicked()        //点击设置
            super.click(location: .zero, open: true)
        }else if node == typeView || node == typeLabel{
            typeClicked()           //点击类型切换
        }else{
            //点击内容判断
            if node == walkingTypebutton {
                typeLabel.text = "走路"
                typeClicked()
            }else if node == hikingTypebutton{
                typeLabel.text = "徒步"
                typeClicked()
            }else if node == runningTypebutton{
                typeLabel.text = "跑步"
                typeClicked()
            }else if node == ridingTypebutton{
                typeLabel.text = "骑行"
                typeClicked()
            }else{
                //其他点击
                super.click(location: location, open: open)
            }
            
        }
    }
    
    //MARK:- 开始按钮点击
    @IBAction func start(_ sender: UIButton) {
        pushMap()
    }
    
    //MARK:- 设置按钮点击
    @IBAction func settingClicked() {
        
        if showType == nil{
            showType = .setting
        }else if showType == .setting{
            showType = nil
        }else{
            showType = nil
            showType = .setting
        }
    }
    
    //MARK:- 类型按钮点击
    @IBAction func typeClicked() {
        if showType == nil{
            showType = .type
        }else if showType == .type{
            showType = nil
        }else{
            showType = nil
            showType = .type
        }
    }
    
    //MARK:- 切换到地图页面
    private func pushMap(){
        
        let mapVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map") as! MapVC
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
}

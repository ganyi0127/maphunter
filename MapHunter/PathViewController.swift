//
//  PathViewController.swift
//  MapHunter
//
//  Created by ganyi on 2017/1/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
//类型子按钮
enum ActiveSportType{
    case walking
    case hiking
    case running
    case riding
}
class PathViewController: FunOriginViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
//    @IBOutlet weak var typeView: UIView!
//    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeButton: UIButton!
    
    private lazy var originTypeviewFrame: CGRect = {
       return self.typeButton.frame
    }()
    private lazy var originStartFrame: CGRect = {
       return self.startButton.frame
    }()
    
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var defaultView: UIView!
    
    override var isOpen: Bool{
        didSet{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                var y: CGFloat
                if self.isOpen {
                    y = self.originTypeviewFrame.origin.y + 64
                    self.startButton.frame.origin.y = self.originStartFrame.origin.y + 1
                }else{
                    y = self.originTypeviewFrame.origin.y
                    self.startButton.frame.origin.y = self.originStartFrame.origin.y
                }
                self.typeButton.frame.origin.y = y
                self.settingButton.frame.origin.y = y
                self.settingView.frame.origin.y = y + self.originTypeviewFrame.height
                self.defaultView.frame.origin.y = y + self.originTypeviewFrame.height
                self.startButton.frame.origin.y = self.defaultView.frame.origin.y + self.defaultView.frame.height
            }, completion: {
                complete in
            })
        }
    }
    
    private var sporttype: ActiveSportType?{
        didSet{
            guard let st = sporttype else {
                return
            }
            typeButton.setImage(sportTypeImgMap[st]!, for: .normal)
        }
    }
    private lazy var sportTypeImgMap: [ActiveSportType: UIImage?] = [.walking: UIImage(named: "resource/map/type/walking"),
                                                               .hiking: UIImage(named: "resource/map/type/hiking"),
                                                               .running: UIImage(named: "resource/map/type/running"),
                                                               .riding: UIImage(named: "resource/map/type/riding")]
    private lazy var typeButtonDoubleFrame: CGRect = {
        return CGRect(x: self.typeButton.frame.origin.x - self.typeButton.bounds.width / 2, y: self.typeButton.frame.origin.y - self.typeButton.bounds.height / 2, width: self.typeButton.bounds.width * 2, height: self.typeButton.bounds.height * 2)
    }()
    private lazy var closeTypeButton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeButtonDoubleFrame)
        let img = UIImage(named: "resource/map/type/close")
        button.setImage(img, for: .normal)
        button.isHidden = true
        button.tag = 0
        return button
    }()
    private lazy var walkingTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeButtonDoubleFrame)
        button.setImage(self.sportTypeImgMap[.walking]!, for: .normal)
        button.isHidden = true
        button.tag = 1
        return button
    }()
    private lazy var hikingTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeButtonDoubleFrame)
        button.setImage(self.sportTypeImgMap[.hiking]!, for: .normal)
        button.isHidden = true
        button.tag = 2
        return button
    }()
    private lazy var runningTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeButtonDoubleFrame)
        button.setImage(self.sportTypeImgMap[.running]!, for: .normal)
        button.isHidden = true
        button.tag = 3
        return button
    }()
    private lazy var ridingTypebutton: UIButton = {
        let button: UIButton = UIButton(frame: self.typeButtonDoubleFrame)
        button.setImage(self.sportTypeImgMap[.riding]!, for: .normal)
        button.isHidden = true
        button.tag = 4
        return button
    }()
    //存储所有标签
    private lazy var typebuttonList: [UIButton] = {
       return [self.closeTypeButton, self.walkingTypebutton, self.hikingTypebutton, self.runningTypebutton, self.ridingTypebutton]
    }()
    
    //按钮类型
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
                defaultView.isHidden = false
                return
            }
            
            defaultView.isHidden = true
            
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
//                self.typeView.frame = CGRect(x: self.typeView.frame.origin.x, y: self.typeView.frame.origin.y, width: self.typeView.frame.width, height: self.originTypeviewFrame.height * 5)
                self.typebuttonList.enumerated().forEach(){
                    index, button in
                    button.isHidden = false
                    button.frame.origin.y = self.originTypeviewFrame.height * CGFloat(index) * 2.2 + self.originTypeviewFrame.height / 2
                }
            }else{
                //关闭
//                self.typeView.frame = CGRect(x: self.typeView.frame.origin.x, y: self.typeView.frame.origin.y, width: self.typeView.frame.width, height: self.originTypeviewFrame.height)
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
        
        //设置效果
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            if flag{
                //展开
                self.settingView.isHidden = false
            }else{
                //关闭
                self.settingView.isHidden = true
            }
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
        sporttype = .walking
        settingView.isHidden = true
        
    }
    
    //圆环
    private lazy var circle0: CAShapeLayer = {
        let shape: CAShapeLayer = CAShapeLayer()
        shape.path = UIBezierPath(ovalIn: self.startButton.bounds).cgPath
        shape.lineWidth = 1
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = nil
        return shape
    }()
    private lazy var circle1: CAShapeLayer = {
        let shape: CAShapeLayer = CAShapeLayer()
        shape.path = UIBezierPath(ovalIn: self.startButton.bounds).cgPath
        shape.lineWidth = 1
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = nil
        return shape
    }()
    private lazy var circleAnim0: CAAnimation = {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = UIBezierPath(ovalIn: CGRect(x:  -5, y: -5, width: 5, height: 5)).cgPath
        anim.repeatCount = HUGE
        anim.duration = 7.9
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeBoth
        return anim
    }()
    private lazy var circleAnim1: CAAnimation = {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = UIBezierPath(ovalIn: CGRect(x:  -5, y: 0, width: 5, height: 5)).cgPath
        anim.repeatCount = HUGE
        anim.duration = 4.3
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeBoth
        return anim
    }()
    
    override func createContents() {
        //添加背景图片
        let backgroundImage = UIImage(named: "resource/map/background/path")!//?.transfromImage(size: view_size)
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = CGRect(origin: .zero, size: view_size)
        backgroundImageView.layer.cornerRadius = 20
        view.insertSubview(backgroundImageView, at: 0)
        
        super.createContents()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        typeView.layer.cornerRadius = originTypeviewFrame.height / 2
        
        //添加类型按钮，使用view添加以获取点击
        if typeButton.subviews.count < 4{
            view.addSubview(closeTypeButton)
            view.addSubview(walkingTypebutton)
            view.addSubview(hikingTypebutton)
            view.addSubview(runningTypebutton)
            view.addSubview(ridingTypebutton)
        }
        
        //设置startButton圆环动画
        startButton.layer.addSublayer(circle0)
        circle0.add(circleAnim0, forKey: nil)
        startButton.layer.addSublayer(circle1)
        circle1.add(circleAnim1, forKey: nil)
    }
    
    deinit {
        if let t = tap {
            view.removeGestureRecognizer(t)
        }
    }
    
    //MARK:- 自定义点击事件
    override func click(location: CGPoint, open: Bool) {
        
        //获取点击view
        guard let node = view.hitTest(location, with: nil) else{
            return
        }
        print("node:", node)
        if node == startButton {
            start(startButton)      //点击开始
        }else if node == settingButton{
            settingClicked()        //点击设置
        }else if node == typeButton{
            typeClicked()           //点击类型切换
        }else if node.viewController().isKind(of: DefaultVC.self){
            pushHistory()           //点击历史轨迹
        }else{
            //点击内容判断
            if node == closeTypeButton {
                typeClicked()
            }else if node == walkingTypebutton {
                sporttype = .walking
                typeClicked()
                OCVariable.share().v_max = 7.5
                OCVariable.share().v_min = 6
            }else if node == hikingTypebutton{
                sporttype = .hiking
                typeClicked()
                OCVariable.share().v_max = 7.5
                OCVariable.share().v_min = 6
            }else if node == runningTypebutton{
                sporttype = .running
                typeClicked()
                OCVariable.share().v_max = 10
                OCVariable.share().v_min = 7.5
            }else if node == ridingTypebutton{
                sporttype = .riding
                typeClicked()
                OCVariable.share().v_max = 25
                OCVariable.share().v_min = 20
            }else{
                //其他点击
                if showType == .type{
                    showType = nil
                }
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
        let settingPathVC = storyboard?.instantiateViewController(withIdentifier: "settingpath") as! SettingPathVC
        navigationController?.pushViewController(settingPathVC, animated: true)
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
    
    @IBAction func clickTypeButton(_ sender: UIButton) {
        super.click(location: .zero, open: false)
    }
    
    @objc private func selectType(_ sender: UIButton){
        switch sender.tag {
        case 1:
            sporttype = .walking
        case 2:
            sporttype = .hiking
        case 3:
            sporttype = .running
        case 4:
            sporttype = .riding
        default:
            break
        }
    }
    
    //MARK:- 切换到历史轨迹
    private func pushHistory(){
        let historyVC = storyboard?.instantiateViewController(withIdentifier: "history") as! HistoryVC
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    //MARK:- 切换到地图页面
    private func pushMap(){
        
        let premapVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "premap") as! PremapVC
        premapVC.activeType = sporttype
        navigationController?.pushViewController(premapVC, animated: true)
    }
    
    
}

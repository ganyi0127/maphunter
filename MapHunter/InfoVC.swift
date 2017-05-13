//
//  InfoVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/15.
//  Copyright © 2017年 ganyi. All rights reserved.
//
//1、根据手机语言，如果是中文，默认是公制， 其他，默认是英制
//2.性别的默认值男，身高默认值 175cm，范围(30cm-255cm)，体重默认值 65kg， 范围(25kg-255kg) 生日的默认值 25 岁，范围:0-250 岁
//3.在设置身高和体重的时候都可以修改公英制

import Foundation
enum InfoGender {      //性别
    case male       //男
    case female     //女
}
class InfoVC: UIViewController {
    
    //图片
    private enum ImageType{
        case genderSel
        case male
        case female
        case height
        case weight
        case birthday
    }
    private let images: [ImageType: UIImage?] = [.genderSel: UIImage(named: "resource/infoset/gender"),
                                                 .male: UIImage(named: "resource/infoset/male"),
                                                 .female: UIImage(named: "resource/infoset/female"),
                                                 .height: UIImage(named: "resource/infoset/height"),
                                                 .weight: UIImage(named: "resource/infoset/weight"),
                                                 .birthday: UIImage(named: "resource/infoset/birthday")]
    
    private let settedColor = defaut_color
    
    //按钮
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //视图
    @IBOutlet weak var genderView: InfoSexView!
    @IBOutlet weak var heightView: InfoHeightView!
    @IBOutlet weak var weightView: InfoWeightView!
    @IBOutlet weak var birthdayView: InfoAgeView!
    
    //图片视图
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var heightImageView: UIImageView!
    @IBOutlet weak var weightImageView: UIImageView!
    @IBOutlet weak var birthdayImageView: UIImageView!
    
    //标签
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    //信息value
    private var gender: InfoGender? {         //性别
        didSet{
            guard let g = gender else {
                return
            }
            
            resetNextButton()
            
            //临时存储
            let value = g == .male ? 1 : 2     //1:男 2:女 0:无选项(默认)
            userDefaults.set(value, forKey: "gender")

            //修改男女图片和文字
            var image: UIImage?
            var text: String
            if g == .male {
                //男
                if let img = images[.male]{
                    image = img
                }
                text = "男"
            }else{
                //女
                if let img = images[.female]{
                    image = img
                }
                text = "女"
            }
            if let img = image {
                genderImageView.image = img
            }
            
            //修改标签
            genderLabel.textColor = settedColor
            genderLabel.text = text
        }
    }
    private var height: UInt8? {        //以厘米为单位
        didSet{
            guard let h = height else {
                return
            }
            
            //修正
            if h < 30 {
                height = 30
                return
            }else if h > 255{
                height = 255
                return
            }
            
            resetNextButton()
            
            //临时存储
            userDefaults.set(Int(h), forKey: "height")
            
            //修改身高文字
            heightLabel.textColor = settedColor
            let text = "\(h)" + "厘米"
            let attributeString = NSMutableAttributedString(string: text,
                                                            attributes: [NSFontAttributeName: fontMiddle])
            attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))
            heightLabel.attributedText = attributeString
        }
    }
    private var weight: CGFloat?{       //以kg为单位
        didSet{
            guard let w = weight else {
                return
            }
            
            //修正
            if w < 25 * 10000 {
                weight = 25 * 10000
                return
            }else if w > 255.9 * 10000{
                weight = 255.9 * 10000
                return
            }
            
            resetNextButton()
            
            //临时存储
            userDefaults.set(Int(w), forKey: "weight")
            
            //修改体重文字
            weightLabel.textColor = settedColor
            let text = String(format: "%.1f", w / 10000) + "公斤"
            let attributeString = NSMutableAttributedString(string: text,
                                                            attributes: [NSFontAttributeName: fontMiddle])
            attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 2, 2))
            weightLabel.attributedText = attributeString
        }
    }
    private var birthday: Date?{        //生日
        didSet{
            guard let d = birthday else {
                return
            }
            
            resetNextButton()
            
            //临时存储 偏移天数
            let today = Date()
            let offsetDays = today.timeIntervalSince(d) / 60 / 60 / 24
            userDefaults.set(offsetDays < 0 ? 0 : offsetDays, forKey: "offsetdays")
            
            //修改生日文字
            birthdayLabel.textColor = settedColor
            let formatter = DateFormatter()
            formatter.dateFormat = "yyy年M月d日"
            let text = formatter.string(from: d)
            
            let components = calender.dateComponents([.month, .day], from: d)
            let offsetMonth = components.day! < 10 ? 3 : 4
            let offsetYear = components.month! < 10 ? offsetMonth + 2 : offsetMonth + 3
            
            let attributeString = NSMutableAttributedString(string: text,
                                                            attributes: [NSFontAttributeName: fontMiddle])
            attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - 1, 1))   //日
            attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - offsetMonth, 1))   //月
            attributeString.addAttribute(NSFontAttributeName, value: fontSmall, range: NSMakeRange(text.characters.count - offsetYear, 1))   //年
            birthdayLabel.attributedText = attributeString
        }
    }
    
    //日历
    private let calender = Calendar.current
    
    //选择器
    private let selector = InfoSelector()
    
    //展开按钮
    private var selectorShow: Bool = false{
        didSet{
            return
            if selectorShow{
                //添加高斯模糊
                effectView.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.effectView.alpha = 1
                }, completion: nil)
                view.insertSubview(effectView, belowSubview: selector)
                effectView.addGestureRecognizer(tap)
                
            }else{
                //移除高斯模糊
                effectView.removeGestureRecognizer(tap)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.effectView.alpha = 0
                }){
                    _ in
                    //当动画结束后、页面为关闭状态时移除效果
                    if !self.selectorShow{
                        self.effectView.removeFromSuperview()
                    }
                }                
            }
        }
    }
    //取消点击事件
    private var tap: UITapGestureRecognizer{
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(recognizer:)))
        tap.numberOfTapsRequired = 1
        return tap
    }
    
    //毛玻璃
    private lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        return effectView
    }()
    
    
    
    
    //MARK:- init******************************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    private func config(){
        
        view.backgroundColor = timeColor
        
        //设置标签字体
        firstLabel.font = fontMiddle
        //设置下一步颜色
        nextButton.setTitleColor(defaut_color, for: .normal)
        nextButton.setTitleColor(UIColor.lightGray, for: .disabled)
        nextButton.isEnabled = false
        //设置返回图片
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
        
        initInfo()      //初始化模块
    }
    
    private func createContents(){
        
        view.addSubview(selector)
        selector.closure = {
            accept, type, value1, value2 in
            
            self.selectorShow = false
            guard accept else {
                return
            }
            
            switch type {
            case .gender:
                if let genderString = value2 as? String{
                    if genderString == "男"{
                        self.gender = .male
                    }else if genderString == "女" {
                        self.gender = .female
                    }
                }
            case .height:
                if let heightValue = value1 as? Int{
                    self.height = UInt8(heightValue)
                }
                if let heightUnitString = value2 as? String{
                    
                }
            case .weight:
                if let weightValue = value1 as? Int{
                    self.weight = CGFloat(weightValue)
                }
                if let weightUnitString = value2 as? String{
                    
                }
            case .birthday:
                if let date = value1 as? Date{
                    self.birthday = date
                }
            }
        }
    }
    
    //MARK:- 初始化模块
    private func initInfo(){
        //设置sublabel字体
        genderLabel.font = fontMiddle
        heightLabel.font = fontMiddle
        weightLabel.font = fontMiddle
        birthdayLabel.font = fontMiddle
        
        //设置sublabel文字颜色
        genderLabel.textColor = lightWordColor
        heightLabel.textColor = lightWordColor
        weightLabel.textColor = lightWordColor
        birthdayLabel.textColor = lightWordColor
        
        //性别
        let udGender = userDefaults.integer(forKey: "gender")
        if udGender == 1 {
            //男
            gender = .male
        }else if udGender == 2{
            //女
            gender = .female
        }else{
            if let img = images[.genderSel]{
                genderImageView.image = img
            }
            genderLabel.text = "性别"
        }
        
        //身高
        let udHeight = userDefaults.integer(forKey: "height")
        if udHeight != 0 {
            height = UInt8(udHeight)
        }else{
            heightLabel.text = "身高"
        }
        if let img = images[.height]{
            heightImageView.image = img
        }
        
        //体重
        let udWeight = userDefaults.integer(forKey: "weight")
        if udWeight != 0{
            weight = CGFloat(udWeight)
        }else{
            weightLabel.text = "体重"
        }
        if let img = images[.weight]{
            weightImageView.image = img
        }
        
        //生日
        let udBirthday = userDefaults.double(forKey: "offsetdays")
        if udBirthday != 0{
            //计算生日
            let today = Date()
            let defaultDate = Date(timeInterval: -udBirthday * 60 * 60 * 24, since: today)
            birthday = defaultDate
        }else{
            birthdayLabel.text = "生日"
        }
        if let img = images[.birthday]{
            birthdayImageView.image = img
        }
        
        //设置模块触摸回调
        genderView.closure = callback
        heightView.closure = callback
        weightView.closure = callback
        birthdayView.closure = callback
    }
    
    //MARK:- 点击回调实现
    private func callback(byInfoType type: InfoType){
        
        selectorShow = true
        selector.switchInput(withType: type)
    }
    
    //MARK:- tap点击事件
    @objc private func tap(recognizer: UITapGestureRecognizer){
        selectorShow = false
        selector.set(hidden: true)
    }
    
    //MARK:- 重新设置nextButton禁用状态
    private func resetNextButton(){
        if !nextButton.isEnabled {
            if checkoutProgress() {
                nextButton.isEnabled = true
            }
        }
    }
    
    //MARK:- 检查是否完成
    private func checkoutProgress() -> Bool{
        return gender != nil && height != nil && weight != nil && birthday != nil
    }
    
    //MARK:- 返回上一层
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到下一层
    @IBAction func next(_ sender: UIButton) {
        //跳转到目标设置
        if let infoTargetVC = UIStoryboard(name: "Info", bundle: Bundle.main).instantiateViewController(withIdentifier: "infotarget") as? InfoTargetVC{
            navigationController?.show(infoTargetVC, sender: nil)
        }
    }
}

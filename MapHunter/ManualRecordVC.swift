//
//  ManualRecordVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/11.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
enum RecordType: Int{
    case sport = 0, sleep, weight, mood, bloodPressure, heartrate
}

class ManualRecordVC: UIViewController {
    
    var type: RecordType!
    
    //选择列表
    var recordTableView: RecordTableView?
    
    //头
    var recordHeaderView: RecordHeaderView?
    
    //毛玻璃
    private lazy var effectView = { () -> UIVisualEffectView in
        let blur: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let effectView: UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        return effectView
    }()
    
    //身心状态
    fileprivate lazy var moodTypeTextField: UITextField? = {
        let textFieldFrame = CGRect(x: 0, y: view_size.height - 40, width: view_size.width, height: 40)
        let textField = UITextField(frame: textFieldFrame)
        textField.text = "感觉不错"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.clearsOnBeginEditing = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.valueChanged(_ :)), for: .valueChanged)
        return textField
    }()
    fileprivate lazy var moodImageView: UIImageView? = {
        let imageViewFrame = CGRect(x: 16, y: view_size.height / 2 - view_size.width / 2 - 16, width: view_size.width - 16 * 2, height: view_size.width - 16 * 2)
        let imageView: UIImageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "resource/sporticons/mood/type_good")
        return imageView
    }()
    fileprivate lazy var moodImageList: [(text: String, image: UIImage?)] = {
        var list = [(text: String, image: UIImage?)]()
        list.append(("Amazing", UIImage(named: "resource/sporticons/mood/type_amazing")))
        list.append(("Pumped Up", UIImage(named: "resource/sporticons/mood/type_pumpedup")))
        list.append(("Enegized", UIImage(named: "resource/sporticons/mood/type_enegized")))
        list.append(("Good", UIImage(named: "resource/sporticons/mood/type_good")))
        list.append(("Meh", UIImage(named: "resource/sporticons/mood/type_meh")))
        list.append(("Dragging", UIImage(named: "resource/sporticons/mood/type_dragging")))
        list.append(("Exhausted", UIImage(named: "resource/sporticons/mood/type_exhausted")))
        list.append(("Totally Done", UIImage(named: "resource/sporticons/mood/type_totallydone")))
        return list
    }()
    fileprivate lazy var moodPrivateButton: UIButton? = {
        let buttonLength: CGFloat = 64
        let buttonFrame = CGRect(x: 0, y: self.view.frame.height - self.moodTypeTextField!.frame.height - buttonLength, width: buttonLength, height: buttonLength)
        let button: UIButton = UIButton(frame: buttonFrame)
        button.setImage(UIImage(named: "resource/sporticons/mood/private_lock")?.transfromImage(size: CGSize(width: 40, height: 40)), for: .normal)
        button.setImage(UIImage(named: "resource/sporticons/mood/private_unlock")?.transfromImage(size: CGSize(width: 40, height: 40)), for: .selected)
        button.addTarget(self, action: #selector(self.privateClick(_ :)), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var moodBackground: UIImageView? = {
        let imageViewFrame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
        let imageView: UIImageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "resource/sporticons/mood/background")
        imageView.isHidden = true
        return imageView
    }()
    fileprivate lazy var moodTipView: UIView? = {
        let tipFrame = CGRect(x: view_size.width * 0.8, y: view_size.height / 2, width: view_size.width * 0.2, height: 1)
        let tipView: UIView = UIView(frame: tipFrame)
        tipView.backgroundColor = .clear
        let upFrame = CGRect(x: 0, y: -view_size.width * 0.2, width: view_size.width * 0.2, height: view_size.width * 0.2)
        let up = UIImageView(frame: upFrame)
        up.image = UIImage(named: "resource/sporticons/mood/scrollup")
        tipView.addSubview(up)
        let downFrame = CGRect(x: 0, y: 0, width: view_size.width * 0.2, height: view_size.width * 0.2)
        let down = UIImageView(frame: downFrame)
        down.image = UIImage(named: "resource/sporticons/mood/scrolldown")
        tipView.addSubview(down)
        let labelFrame = CGRect(x: 0, y: -10, width: view_size.width * 0.2, height: 20)
        let label = UILabel(frame: labelFrame)
        label.textAlignment = .center
        label.text = "滑动"
        label.textColor = wordColor
        tipView.addSubview(label)
        return tipView
    }()
    
    //MARK:- init**************************************************************************************************
    init(withRecordType type: RecordType){
        super.init(nibName: nil, bundle: nil)
        
        //存储类型
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        
        //绘制背景
        view.backgroundColor = .white
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let startColor = recordStartColors[type!]!
        let endColor = recordEndColors[type!]!
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.addSublayer(gradient)
        
        //键盘事件
        if type == .mood{
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    
    func createContents(){
        
        //设置按钮图片大小
        let buttonImageSize = CGSize(width: 20, height: 20)
        
        //添加取消按钮
        let refuseButtonFrame = CGRect(x: 0, y: 20, width: 64, height: 44)
        let refuseButton = UIButton(frame: refuseButtonFrame)
        if let img = UIImage(named: "resource/target/target_refuse_normal")?.transfromImage(size: buttonImageSize){
            refuseButton.setImage(img, for: .normal)
        }
        refuseButton.addTarget(self, action: #selector(refuse(sender:)), for: .touchUpInside)
        view.addSubview(refuseButton)
        
        //添加确认按钮
        let acceptButtonFrame = CGRect(x: view_size.width - 64, y: 20, width: 64, height: 44)
        let acceptButton = UIButton(frame: acceptButtonFrame)
        if let img = UIImage(named: "resource/target/target_accept_normal")?.transfromImage(size: buttonImageSize){
            acceptButton.setImage(img, for: .normal)
        }
        acceptButton.addTarget(self, action: #selector(accept(sender:)), for: .touchUpInside)
        view.addSubview(acceptButton)
        
        //添加记录选择器
        if type != RecordType.mood {
            recordTableView = RecordTableView(withRecordType: type)
            
            recordTableView?.openClosure = {
                recordType, isOpen in
                
                switch recordType {
                case .sport:
                    //更新header视图
                    let sportType = RecordTableView.sportType
                    self.recordHeaderView?.sportType = sportType
                case .sleep:
                    if let sleepDate = RecordTableView.sleepDate, let wakeDate = RecordTableView.wakeDate{
                        let timeInterval = wakeDate.timeIntervalSince(sleepDate)
                        let minute = lroundf(Float(timeInterval / 60))
                        self.recordHeaderView?.sleepMinute = minute
                    }
                case .weight:
                    self.recordHeaderView?.weightDataList = [
                        (date: Date(), weight: 65.4),
                        (date: Date(), weight: 88.9),
                        (date: Date(), weight: 23.2),
                        (date: Date(), weight: 76.4),
                        (date: Date(), weight: 76.4),
                        (date: Date(), weight: 65.4),
                        (date: Date(), weight: 88.9),
                        (date: Date(), weight: 23.2),
                        (date: Date(), weight: 76.4),
                        (date: Date(), weight: 89.4),
                        (date: Date(), weight: 87.4),
                        (date: Date(), weight: 88.9),
                        (date: Date(), weight: 44.2),
                        (date: Date(), weight: 35.4)
                    ]
                    self.recordHeaderView?.weightTarget = 65.5
                case .bloodPressure:
                    self.recordHeaderView?.bloodPressureDataList = [
                        (date: Date(), diastolic: 120, systolic: 80),
                        (date: Date(), diastolic: 200, systolic: 180),
                        (date: Date(), diastolic: 80, systolic: 20),
                        (date: Date(), diastolic: 50, systolic: 39),
                        (date: Date(), diastolic: 244, systolic: 187),
                        (date: Date(), diastolic: 250, systolic: 199),
                        (date: Date(), diastolic: 50, systolic: 93),
                        (date: Date(), diastolic: 40, systolic: 70),
                        (date: Date(), diastolic: 170, systolic: 80),
                        (date: Date(), diastolic: 140, systolic: 111),
                        (date: Date(), diastolic: 135, systolic: 102),
                        (date: Date(), diastolic: 120, systolic: 100),
                        (date: Date(), diastolic: 120, systolic: 80),
                        (date: Date(), diastolic: 90, systolic: 70),
                        (date: Date(), diastolic: 70, systolic: 50)
                    ]
                    self.recordTableView?.header?.leftDate = Date()
                    self.recordTableView?.header?.rightDate = Date()
                case .heartrate:
                    self.recordHeaderView?.heartrateDataList = [
                        (date: Date(), heartrate: 65),
                        (date: Date(), heartrate: 80),
                        (date: Date(), heartrate: 93),
                        (date: Date(), heartrate: 123),
                        (date: Date(), heartrate: 153),
                        (date: Date(), heartrate: 143),
                        (date: Date(), heartrate: 103),
                        (date: Date(), heartrate: 83),
                        (date: Date(), heartrate: 79)
                    ]
                default:
                    //身心状态不进行处理
                    break
                }
                
                if isOpen{
                    if self.effectView.superview == nil{
                        self.effectView.alpha = 0
                        self.view.insertSubview(self.effectView, at: 1)
                    }
                }else{
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    if isOpen{
                        self.recordHeaderView?.alpha = 0
                        self.effectView.alpha = 1
                    }else{
                        self.recordHeaderView?.alpha = 1
                        self.effectView.alpha = 0
                    }
                }, completion: {
                    complete in
                    guard complete else{
                        return
                    }
                    
                    if isOpen{
                        
                    }else{
                        if self.effectView.superview != nil{
                            self.effectView.removeFromSuperview()
                        }
                    }
                })
            }
            
            recordHeaderView = RecordHeaderView(withRecordType: type, top: recordTableView!.openOriginY, bottom: recordTableView!.closeOriginY)
            view.insertSubview(recordHeaderView!, belowSubview: recordTableView!)
            
            view.addSubview(recordTableView!)
        }else{
            //身心状态
            view.addSubview(moodBackground!)
            view.addSubview(moodTipView!)
            view.addSubview(moodImageView!)
            view.addSubview(moodPrivateButton!)
            view.addSubview(moodTypeTextField!)
        }
    }
    
    //MARK:- 点击按钮 同意
    @objc func accept(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 点击按钮 拒绝
    @objc private func refuse(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 复制判断
    func valueChanged(_ sender: UITextField) {
        guard sender.text != nil else{
            return
        }
        
        //判断账号或密码
        let maxLength: Int = 500
        
        //限制字符数
        if (sender.text?.lengthOfBytes(using: String.Encoding.utf8))! > maxLength{
            while sender.text!.lengthOfBytes(using: String.Encoding.utf8) > maxLength {
                
                let endIndex = sender.text!.index(sender.text!.endIndex, offsetBy: -1)
                let range = Range(sender.text!.startIndex..<endIndex)
                sender.text = sender.text!.substring(with: range)
            }
        }
    }
    
    //MARK:- 保密按钮点击
    @objc private func privateClick(_ sender: Any){
        moodPrivateButton?.isSelected = !moodPrivateButton!.isSelected
    }
}

//MARK:- 触摸事件
extension ManualRecordVC{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == .mood {
            moodTypeTextField?.resignFirstResponder()
        }else{
            recordHeaderView?.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == .mood {
            
            moodTipView?.isHidden = true
            
            guard let touch = touches.first else {
                return
            }
            
            let location = touch.location(in: view)
            let y = location.y
            let height = view.frame.height - moodTypeTextField!.frame.height
            let index = Int(y) / (Int(height) / moodImageList.count)
            if index < moodImageList.count {
                moodImageView?.image = moodImageList[index].image
                moodTypeTextField?.text = moodImageList[index].text
                
                if index == 0 {
                    moodBackground?.isHidden = false
                }else{
                    moodBackground?.isHidden = true
                }
            }
        }else{
            recordHeaderView?.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == .mood{
        }else{
            recordHeaderView?.touchesEnded(touches, with: event)
        }
    }
}

//MARK:- 身心状态输入
extension ManualRecordVC: UITextFieldDelegate{
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moodTypeTextField?.resignFirstResponder()
        return false
    }
    
    //键盘弹出
    func keyboardWillShow(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let keyboardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let offset = keyboardBounds.size.height
        
        let animations = {
            let keyboardTransform = CGAffineTransform(translationX: 0, y: -offset)
            self.moodTypeTextField?.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
    //键盘回收
    func keyboardWillHide(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations = {
            let keyboardTransform = CGAffineTransform.identity
            self.moodTypeTextField?.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    //复制判断
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existedLength = textField.text?.lengthOfBytes(using: .utf8)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytes(using: .utf8)
        
        let maxLenght: Int = 500
        
        if existedLength! - selectedLength + replaceLength > maxLenght{
            return false
        }
        
        return true
    }
}

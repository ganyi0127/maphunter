//
//  TrackVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/6/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import AngelFit
class TrackVC: UIViewController {
    
    private var track: EachTrainningData!
    
    fileprivate var trackSV: TrackSV!
    
    private lazy var commentTextfield: UITextField = {
        let textfieldFrame = CGRect(x: 0, y: 1, width: view_size.width - 64, height: 44 - 1)
        let textfield: UITextField = UITextField(frame: textfieldFrame)
        textfield.attributedPlaceholder = NSAttributedString(string: "添加评论")
        textfield.borderStyle = UITextBorderStyle.none
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var commentButton: UIButton = {
        let buttonFrame = CGRect(x: view_size.width - 64, y: 1, width: 64, height: 44 - 1)
        let button: UIButton = UIButton(frame: buttonFrame)
        button.setTitle("发布", for: .normal)
        button.setTitleColor(subWordColor, for: .normal)
        button.addTarget(self, action: #selector(self.comment(sender:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var commentView: UIView = {
        let commentFrame = CGRect(x: 0, y: view_size.height - 44, width: view_size.width, height: 44)
        let commentView: UIView = UIView(frame: commentFrame)
        commentView.backgroundColor = .white
        
        commentView.addSubview(self.commentTextfield)
        commentView.addSubview(self.commentButton)
        
        //添加分割线
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: view_size.width, height: 1))
        separator.backgroundColor = subWordColor
        separator.alpha = 0.1
        commentView.addSubview(separator)
        
        return commentView
    }()
    
    //MARK:-init************************************************************************************
    init(with track: EachTrainningData){
        super.init(nibName: nil, bundle: nil)
        
        self.track = track
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigation(hidden: true)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white]
        
        //显示日期
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        
        let dateStr = formatter.string(from: track.date! as Date)
        let todayStr = formatter.string(from: Date())
        
        if dateStr == todayStr {
            navigationItem.title = "今天"
        }else{
            navigationItem.title = dateStr
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        view.backgroundColor = .clear
        
        //绘制渐变
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.locations = [-0.6, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        var startColor: UIColor!
        startColor = .orange
        gradient.colors = [startColor.cgColor, timeColor.cgColor]
        //gradient.cornerRadius = 10
        view.layer.addSublayer(gradient)
        
        //键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func createContents(){
        
        //添加scrollView
        trackSV = TrackSV(with: track)
        view.addSubview(trackSV)
        
        //添加评论面板
        view.addSubview(commentView)
    }
    
    @objc private func comment(sender: UIButton){
        commentTextfield.resignFirstResponder()
    }
}


extension TrackVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
            self.commentView.transform = keyboardTransform
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
            self.commentView.transform = keyboardTransform
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
        
        let maxLenght = 500

        if existedLength! - selectedLength + replaceLength > maxLenght{
            return false
        }
        
        return true
    }
}

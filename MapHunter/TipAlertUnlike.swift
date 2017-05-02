//
//  TipAlertUnlike.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/2.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class TipAlertUnlike: TipAlert {
    
    fileprivate var feedbackTextView: UITextView?
    
    private var tap: UITapGestureRecognizer?
    
    override func config() {
        super.config()
        let height = view_size.height * 0.6
        let width = view_size.width - 16 * 2
        frame = CGRect(x: view_size.width / 2 - width / 2, y: view_size.height / 2 - height / 2, width: width, height: height)
        
        //键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(click(tap:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        addGestureRecognizer(tap!)
    }
    
    deinit {
        if let t = tap{
            removeGestureRecognizer(t)
        }
    }
    
    override func createContents() {
        super.createContents()
        
        //图标
        let imageSize = CGSize(width: 60, height: 60)
        let imageViewFrame = CGRect(x: frame.width / 2 - imageSize.width / 2, y: 20, width: imageSize.width, height: imageSize.height)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "resource/time/sorry")
        addSubview(imageView)
        
        //抬头文字
        let titleLabelFrame = CGRect(x: 0, y: imageViewFrame.origin.y + imageViewFrame.height, width: frame.width, height: 36)
        let titleLabel = UILabel(frame: titleLabelFrame)
        titleLabel.font = fontMiddle
        titleLabel.textColor = wordColor
        titleLabel.text = "抱歉"
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        //详情文字
        let detailLabelFrame = CGRect(x: 8, y: titleLabelFrame.origin.y + titleLabelFrame.height, width: frame.width - 8 * 2, height: 26)
        let detailLabel = UILabel(frame: detailLabelFrame)
        detailLabel.font = fontSmall
        detailLabel.numberOfLines = 3
        detailLabel.lineBreakMode = .byCharWrapping
        detailLabel.textColor = subWordColor
        detailLabel.text = "今后这样的内容会减少，您能说明为什么不想看这些么？"
        addSubview(detailLabel)
        detailLabel.sizeToFit()
        
        //反馈框
        let textviewHeight = frame.width - detailLabelFrame.origin.y - detailLabel.frame.height - 8 - 36
        let textviewFrame = CGRect(x: 8, y: detailLabelFrame.origin.y + detailLabel.frame.height, width: frame.width - 8 * 2, height: textviewHeight)
        feedbackTextView = UITextView(frame: textviewFrame)
        feedbackTextView?.delegate = self
        feedbackTextView?.text = "您对哈博士有何建议？"
        feedbackTextView?.textColor = subWordColor
        feedbackTextView?.font = fontSmall
        feedbackTextView?.autocorrectionType = .no
        feedbackTextView?.autocapitalizationType = .none
        feedbackTextView?.keyboardType = .default
        feedbackTextView?.isScrollEnabled = false
        
        feedbackTextView?.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView?.layer.borderWidth = 1
        feedbackTextView?.layer.cornerRadius = 2
        feedbackTextView?.layer.masksToBounds = true
        addSubview(feedbackTextView!)
        
        //提交
        let submitButtonFrame = CGRect(x: 8, y: textviewFrame.origin.y + textviewFrame.height, width: frame.width - 8 * 2, height: 36)
        let submitButton = UIButton(frame: submitButtonFrame)
        submitButton.setTitle("提交", for: .normal)
        submitButton.setTitleColor(defaut_color, for: .normal)
        submitButton.setTitleColor(.lightGray, for: .highlighted)
        submitButton.addTarget(self, action: #selector(submit(sender:)), for: .touchUpInside)
        addSubview(submitButton)
    }
    
    @objc private func click(tap: UITapGestureRecognizer){
        feedbackTextView?.endEditing(true)
    }
    
    override func cancel(sender: UIButton) {
        feedbackTextView?.endEditing(true)
        super.cancel(sender: sender)
    }
    //MARK:- 提交
    @objc private func submit(sender: UIButton){
        if let feedbackText = feedbackTextView?.text{
            debugPrint("<HaTip>feedback: " + feedbackText)
        }
        feedbackTextView?.endEditing(true)
        removeFromSuperview()
    }
}

extension TipAlertUnlike: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    //键盘弹出
    func keyboardWillShow(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let keyboardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let offset = keyboardBounds.size.height
        
        let animations = {
            let keyboardTransform = CGAffineTransform(translationX: 0, y: -offset * 0.3)
            self.transform = keyboardTransform
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
            self.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    //复制判断
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let existedLength = textView.text?.lengthOfBytes(using: .utf8)
        let selectedLength = range.length
        let replaceLength = text.lengthOfBytes(using: .utf8)
        
        let maxLenght: Int = 180
        if existedLength! - selectedLength + replaceLength > maxLenght{
            return false
        }
        
        return true
    }
    
    
}

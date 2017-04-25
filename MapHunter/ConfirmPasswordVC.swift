//
//  ConfirmPasswordVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class ConfirmPasswordVC: UIViewController {
    
    @IBOutlet weak var firstPasswordSeparatorLine: UIView!        //线->密码1
    @IBOutlet weak var secondPasswordSeparatorLine: UIView!       //线->密码2
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var firstPasswordTextfield: UITextField!
    @IBOutlet weak var secondPasswordTextfiel: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lowNavigation: UIView!
    
    fileprivate let passwordMinLength = 6           //密码最小长度
    fileprivate let passwordMaxLength = 20          //密码最大长度
    
    var account: String?
    var verifyCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func config(){
        
        //键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tipLabel.text = ""
        tipLabel.font = fontSmall
        tipLabel.textColor = defaut_color
        firstPasswordSeparatorLine.backgroundColor = separatorColor
        secondPasswordSeparatorLine.backgroundColor = separatorColor
        nextButton.isEnabled = false
        nextButton.setTitleColor(defaut_color, for: .normal)
        nextButton.setTitleColor(.lightGray, for: .disabled)
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    private func createContents(){
        
    }
    
    fileprivate func isPasswordLegel() -> Bool{
        //判断密码是否为空
        guard let firstPassword: String = firstPasswordTextfield.text, !firstPassword.characters.isEmpty, firstPassword.characters.count >= passwordMinLength else{
            tipLabel.text = "密码长度为\(passwordMinLength)~\(passwordMaxLength)之间"
            return false
        }
        
        guard let secondPassword: String = firstPasswordTextfield.text, !secondPassword.characters.isEmpty, secondPassword.characters.count >= passwordMinLength else{
            tipLabel.text = "密码长度为\(passwordMinLength)~\(passwordMaxLength)之间"
            return false
        }
        
        guard firstPassword == secondPassword else {
            return false
            tipLabel.text = "密码不一致"
        }
        
        tipLabel.text = ""
        
        return true
    }
    
    //MARK:- 返回上一层
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstPasswordSeparatorLine.backgroundColor = separatorColor
        secondPasswordSeparatorLine.backgroundColor = separatorColor
        
        firstPasswordTextfield.resignFirstResponder()
        secondPasswordTextfiel.resignFirstResponder()
    }
    //MARK:- 跳转到更新密码页面
    @IBAction func next(_ sender: UIButton) {
        
        firstPasswordSeparatorLine.backgroundColor = separatorColor
        secondPasswordSeparatorLine.backgroundColor = separatorColor
        
        firstPasswordTextfield.endEditing(true)
        secondPasswordTextfiel.endEditing(true)

        guard isPasswordLegel() else {
            return
        }
        
        //loading视图
        beginLoading()
        
        //修改密码
        ACAccountManager.resetPassword(withAccount: account, verifyCode: verifyCode, password: firstPasswordTextfield.text!){
            uid, error in
            DispatchQueue.main.async {
                
                self.endLoading()   //停止loading
                if let err = error{
                    debugPrint("<register error> uid: \(String(describing: uid)), \(err)")
                    self.tipLabel.text = "修改密码错误"
                    return
                }
                debugPrint("<register success> uid: \(String(describing: uid)), error: nil")
                self.tipLabel.text = "修改密码成功"
            }
        }
        
        //修改密码成功并载入登录
        if let bootLoginVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "bootlogin") as? BootLoginVC {
            navigationController?.show(bootLoginVC, sender: nil)
        }
    }
    
    //MARK:- 输入判断
    @IBAction func valueChanged(_ sender: UITextField) {
        guard sender.text != nil else{
            return
        }
        
        setDoneButtonEnable()
        
        //限制字符数
        if (sender.text?.lengthOfBytes(using: String.Encoding.utf8))! > passwordMaxLength{
            while sender.text!.lengthOfBytes(using: String.Encoding.utf8) > passwordMaxLength {
                
                let endIndex = sender.text!.index(sender.text!.endIndex, offsetBy: -1)
                let range = Range(sender.text!.startIndex..<endIndex)
                sender.text = sender.text!.substring(with: range)
            }
        }
    }
    
    @IBAction func editingBegin(_ sender: UITextField) {
        setDoneButtonEnable()
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        setDoneButtonEnable()
    }
    
    //MARK:- 检查登录或注册按钮是否可选
    fileprivate func setDoneButtonEnable(){
        nextButton.isEnabled = isPasswordLegel()
    }
}

//MARK:- textfield delegate
extension ConfirmPasswordVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == firstPasswordTextfield {
            firstPasswordSeparatorLine.backgroundColor = defaut_color
            secondPasswordSeparatorLine.backgroundColor = separatorColor
        }else if textField == secondPasswordTextfiel{
            firstPasswordSeparatorLine.backgroundColor = separatorColor
            secondPasswordSeparatorLine.backgroundColor = defaut_color
        }
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstPasswordSeparatorLine.backgroundColor = separatorColor
        if textField.tag == 0{
            secondPasswordSeparatorLine.backgroundColor = defaut_color
            secondPasswordTextfiel.becomeFirstResponder()
        }else if textField.tag == 1{
            secondPasswordSeparatorLine.backgroundColor = separatorColor
            textField.resignFirstResponder()
        }
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
            self.lowNavigation.transform = keyboardTransform
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
            self.lowNavigation.transform = keyboardTransform
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
        if existedLength! - selectedLength + replaceLength > passwordMaxLength{
            return false
        }
        return true
    }
}

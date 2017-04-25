//
//  FindPasswordVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/18.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class FindPasswordVC: UIViewController {
    
    @IBOutlet weak var accountSeparatorLine: UIView!        //线->账号
    @IBOutlet weak var verificationSeparatorLine: UIView!   //线->验证码
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var verificationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lowNavigtion: UIView!
    
    
    
    fileprivate let passwordMinLength = 6           //密码最小长度
    fileprivate let passwordMaxLength = 20          //密码最大长度
    fileprivate let verifyLenght = 6                //验证码长度
    fileprivate let accountMinLength = 4            //账号最小长度
    fileprivate let accountMaxLength = 32           //账号最大长度
    
    private var mailAddress: String?
    
    //MARK:- init ***************************************
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
        
        
        if let account = userDefaults.string(forKey: "account"){
            accountTextField.text = account
        }
        tipLabel.text = ""
        tipLabel.font = fontSmall
        tipLabel.textColor = defaut_color
        accountSeparatorLine.backgroundColor = separatorColor
        verificationSeparatorLine.backgroundColor = separatorColor
        verificationButton.setTitleColor(defaut_color, for: .normal)
        verificationButton.setTitleColor(.lightGray, for: .disabled)
        verificationButton.isEnabled = isEmailLegal(emailString: accountTextField.text)
        nextButton.setTitleColor(defaut_color, for: .normal)
        nextButton.setTitleColor(.lightGray, for: .disabled)
        nextButton.isEnabled = false
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 检查邮箱是否合法
    fileprivate func isEmailLegal(emailString string: String?) -> Bool{
        //判断账号是否为空
        guard let account: String = string, !account.characters.isEmpty else {
            tipLabel.text = "邮箱不能为空"
            return false
        }
        
        //判断账号是否合法
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = Regex(mailPattern)
        let maybeMailAddress = account
        guard matcher.match(input: maybeMailAddress) else{
            tipLabel.text = "邮箱格式非法"
            verificationButton.isEnabled = false
            return false
        }
        
        tipLabel.text = ""
        verificationButton.isEnabled = true
        return true
    }
    
    //MARK:- 检查验证码是否合法
    fileprivate func isVerifyCodeLegal(verifyCode string: String?) -> Bool{
        //判断验证码是否为空
        guard let verifyCode = verificationTextField.text, verifyCode.characters.count == verifyLenght else {
            tipLabel.text = "请输入六位验证码"
            return false
        }
        tipLabel.text = ""
        return true
    }
    
    //MARK:- 点击获取验证码
    @IBAction func getVerificationCode(_ sender: UIButton){
        accountSeparatorLine.backgroundColor = separatorColor
        verificationSeparatorLine.backgroundColor = separatorColor
        accountTextField.endEditing(true)
        verificationTextField.endEditing(true)
        
        if isEmailLegal(emailString: accountTextField.text) {
            //存储该邮箱
            mailAddress = accountTextField.text
        }
    }
    
    //MARK:- 返回上一层
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 跳转到更新密码页面
    @IBAction func next(_ sender: UIButton) {
        
        accountSeparatorLine.backgroundColor = separatorColor
        verificationSeparatorLine.backgroundColor = separatorColor
        
        accountTextField.endEditing(true)
        verificationTextField.endEditing(true)
        
        //判断账号是否为空
        guard let account: String = mailAddress else{
            tipLabel.text = "未获取的邮箱地址"
            return
        }
        
        //判断验证码
        guard let verifyCode = verificationTextField.text, isVerifyCodeLegal(verifyCode: verifyCode) else {
            return
        }
        
        //loading视图
        //        beginLoading()
        
        //判断验证码是否正确
        
        
        //跳转到修改密码页面
        if let confirmPasswordVC = UIStoryboard(name: "Boot", bundle: Bundle.main).instantiateViewController(withIdentifier: "confirmpassword") as? ConfirmPasswordVC{
            confirmPasswordVC.account = account
            confirmPasswordVC.verifyCode = ""
            navigationController?.show(confirmPasswordVC, sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accountSeparatorLine.backgroundColor = separatorColor
        verificationSeparatorLine.backgroundColor = separatorColor
        
        accountTextField.resignFirstResponder()
        verificationTextField.resignFirstResponder()
    }
    
    //MARK:- 输入判断
    @IBAction func valueChanged(_ sender: UITextField) {
        guard sender.text != nil else{
            return
        }
        
        //根据邮箱是否非法判断是否显示获取验证码按钮
        let emailLegalFlag = isEmailLegal(emailString: accountTextField.text)
        verificationButton.isEnabled =  emailLegalFlag
        nextButton.isEnabled = emailLegalFlag && (verificationTextField.text?.lengthOfBytes(using: .utf8) == 6)
        
        //判断账号或密码
        var maxLength: Int                      //输入最大长度
        if sender.tag == 0{
            maxLength = accountMaxLength        //取账号最大长度
        }else{
            maxLength = 6                       //验证码长度
        }
        
        setDoneButtonEnable()
        
        //限制字符数
        if (sender.text?.lengthOfBytes(using: String.Encoding.utf8))! > maxLength{
            while sender.text!.lengthOfBytes(using: String.Encoding.utf8) > maxLength {
                
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
        nextButton.isEnabled = isEmailLegal(emailString: accountTextField.text) && isVerifyCodeLegal(verifyCode: verificationTextField.text)
    }
}

//MARK:- textfield delegate
extension FindPasswordVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
            accountSeparatorLine.backgroundColor = defaut_color
            verificationSeparatorLine.backgroundColor = separatorColor
        }else if textField == verificationTextField{
            accountSeparatorLine.backgroundColor = separatorColor
            verificationSeparatorLine.backgroundColor = defaut_color
        }
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        accountSeparatorLine.backgroundColor = separatorColor
        if textField.tag == 0{
            verificationSeparatorLine.backgroundColor = defaut_color
            verificationTextField.becomeFirstResponder()
        }else if textField.tag == 1{
            verificationSeparatorLine.backgroundColor = separatorColor
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
            self.lowNavigtion.transform = keyboardTransform
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
            self.lowNavigtion.transform = keyboardTransform
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

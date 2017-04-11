//
//  BootRegisterVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/7.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class BootRegisterVC: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var clause1: UISwitch!
    @IBOutlet weak var clause2: UISwitch!
    
    fileprivate let passwordMinLength = 6           //密码最小长度
    fileprivate let passwordMaxLength = 20          //密码最大长度
    fileprivate let accountMinLength = 4            //账号最小长度
    fileprivate let accountMaxLength = 32           //账号最大长度
    
    
    private var mailAddress: String?                //存储合法邮箱地址
    
    //MARK:- init
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
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 点击获取验证码
    @IBAction func getVerificationCode(_ sender: UIButton){
        accountTextField.endEditing(true)
        verificationTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        //判断账号是否为空
        guard let account: String = accountTextField.text, !account.characters.isEmpty else {
            let alertController = UIAlertController(title: "账号格式不正确", message: "邮箱不能为空", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        //判断账号是否合法
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = Regex(mailPattern)
        let maybeMailAddress = account
        guard matcher.match(input: maybeMailAddress) else{
            let alertController = UIAlertController(title: "账号格式不正确", message: "请输入正确的邮箱", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        //存储该邮箱
        mailAddress = account
    }
    
    //MARK:- 点击勾选条款
    @IBAction func acceptSwitch(_ sender: UISwitch) {
        let tag = sender.tag
        
        //当勾选条款情况下，允许注册
        if clause1.isOn && clause2.isOn {
            registerButton.isEnabled = true
        }else{
            registerButton.isEnabled = false
        }
        
        if tag == 0 {
            //FunSport使用条款
        }else if tag == 1{
            //FunSport隐私条款
            
        }
    }
    
    //MARK:- 点击返回登录
    @IBAction func backToLogin(_ sender: UIButton) {
        
        //返回登录页面
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 点击注册
    @IBAction func register(_ sender: UIButton) {
        
        accountTextField.endEditing(true)
        verificationTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        //判断账号是否为空
        guard let account: String = mailAddress else{
            let alertController = UIAlertController(title: "账号错误", message: "未获取的邮箱地址", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        //判断密码是否为空
        guard let password: String = passwordTextField.text, !password.characters.isEmpty, password.characters.count >= passwordMinLength else{
            let alertController = UIAlertController(title: "密码格式不正确", message: "密码长度为\(passwordMinLength)~\(passwordMaxLength)之间", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        //判断是否勾选点击勾选条款
        guard clause1.isOn, clause2.isOn else {
            return
        }
        
        //loading视图
        //        beginLoading()
        
        //账号密码注册
        var body = [String:String]()
        body["username"] = account
        body["password"] = password
        
        //注册成功并载入权限设置页面
        let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
        present(rootTBC, animated: true, completion: nil)
    }
    
    //MARK:- 第三方登录
    @IBAction func thirdLogin(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 0 {
            //facebook
        }else if tag == 1{
            //twitter
        }else if tag == 2{
            //微博
        }
    }
    
    //MARK:- 显示密码
    @IBAction func displayPassword(_ sender: UIButton) {
        
    }
    
    //MARK:- 点击事件 回收键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //MARK:- 输入判断
    @IBAction func editingChanged(_ sender: UITextField) {
        guard sender.text != nil else{
            return
        }
        
        //判断账号或密码
        var maxLength: Int                      //输入最大长度
        if sender.tag == 0{
            maxLength = accountMaxLength        //取账号最大长度
        }else{
            maxLength = passwordMaxLength       //取密码最大长度
        }
        
        //限制字符数
        if (sender.text?.lengthOfBytes(using: String.Encoding.utf8))! > maxLength{
            while sender.text!.lengthOfBytes(using: String.Encoding.utf8) > maxLength {
                
                let endIndex = sender.text!.index(sender.text!.endIndex, offsetBy: -1)
                let range = Range(sender.text!.startIndex..<endIndex)
                sender.text = sender.text!.substring(with: range)
            }
        }
    }
}

//MARK:- textfield delegate
extension BootRegisterVC: UITextFieldDelegate{
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            passwordTextField.becomeFirstResponder()
        }else if textField.tag == 1{
            textField.resignFirstResponder()
            register(registerButton)
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

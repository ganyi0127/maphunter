//
//  BootLoginVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
import CoreLocation
import HealthKit
class BootLoginVC: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!   //账号输入
    @IBOutlet weak var passwordTextField: UITextField!  //密码输入
    @IBOutlet weak var accountSeparatorLine: UIView!    //线->账号
    @IBOutlet weak var passwordSeparatorLine: UIView!   //线->密码
    @IBOutlet weak var loginButton: UIButton!           //登录按钮
    @IBOutlet weak var registButton: UIButton!          //注册按钮
    @IBOutlet weak var findPasswordButton: UIButton!    //找回密码按钮
    @IBOutlet weak var tipLabel: UILabel!               //提示标签
    @IBOutlet weak var backButton: UIButton!            //返回按钮
    @IBOutlet weak var lowNiavigation: UIView!          //底部导航视图
    @IBOutlet weak var showButton: UIButton!            //显示密码按钮
    @IBOutlet var thirdView: UIView!                    //第三方view
    @IBOutlet weak var emptyView: UIView!               //底部view

    //第三方登录
    @IBOutlet weak var thirdLoginButton0: UIButton!        //1
    @IBOutlet weak var thirdLoginButton1: UIButton!        //2
    @IBOutlet weak var thirdLoginButton2: UIButton!        //3
    
    
    fileprivate let passwordMinLength = 6           //密码最小长度
    fileprivate let passwordMaxLength = 20          //密码最大长度
    fileprivate let accountMinLength = 4            //账号最小长度
    fileprivate let accountMaxLength = 32           //账号最大长度
    
    //是否显示密码
    fileprivate var isShowPassword = false{
        didSet{
            passwordTextField.isSecureTextEntry = !isShowPassword
        }
    }
    
    //MARK:- init ******************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private var bottomImageView: UIImageView?       //底部图片
    private var thirdImageView: UIImageView?        //第三方登录图片
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //手动添加背景图片
        if bottomImageView == nil{
            if let originImage = UIImage(named: "resource/boot/bg_bottom"){
                let originSize = originImage.size
                let imageSize = CGSize(width: view_size.width, height: view_size.width * originSize.height / originSize.width)
                let bottomImage = originImage.transfromImage(size: imageSize)
                bottomImageView = UIImageView(frame: CGRect(x: 0,
                                                            y: emptyView.frame.height - imageSize.height,
                                                            width: imageSize.width,
                                                            height: imageSize.height))
                bottomImageView?.image = bottomImage
                emptyView.addSubview(bottomImageView!)
            }
        }
        
        //手动添加第三方登录图片
        if thirdImageView == nil{
            if let originImage = UIImage(named: "resource/boot/third_title"){
                let originSize = originImage.size
                let imageWidth = view_size.width * 0.8
                let imageSize = CGSize(width: imageWidth, height: imageWidth * originSize.height / originSize.width)
                let thirdImage = originImage.transfromImage(size: imageSize)
                thirdImageView = UIImageView(frame: CGRect(x: thirdView.frame.width / 2 - imageWidth / 2,
                                                           y: thirdView.frame.height - imageSize.height,
                                                           width: imageSize.width,
                                                           height: imageSize.height))
                thirdImageView?.image = thirdImage
                thirdView.addSubview(thirdImageView!)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func config(){
        //键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //初始化控件
        if let account = userDefaults.string(forKey: "account"){
            accountTextField.text = account
        }
        
        accountTextField.placeholder = "输入邮箱"
        passwordTextField.placeholder = "输入密码"
        accountSeparatorLine.backgroundColor = separatorColor
        passwordSeparatorLine.backgroundColor = separatorColor
        loginButton.setTitleColor(defaut_color, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .disabled)
        loginButton.isEnabled = false
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
        tipLabel.text = ""
        tipLabel.font = fontSmall
        tipLabel.textColor = defaut_color
        showButton.tintColor = .clear
        showButton.setBackgroundImage(UIImage(named: "resource/boot/show_on")?.transfromImage(size: CGSize(width: 24, height: 24)), for: .normal)
        showButton.setBackgroundImage(UIImage(named: "resource/boot/show_off")?.transfromImage(size: CGSize(width: 24, height: 24)), for: .selected)
        showButton.isHidden = true
        registButton.setTitleColor(defaut_color, for: .normal)
        registButton.titleLabel?.font = fontSmall
        registButton.isHidden = true        //需隐藏
        findPasswordButton.setTitleColor(defaut_color, for: .normal)
        findPasswordButton.titleLabel?.font = fontSmall
        thirdLoginButton0.tintColor = .clear
        thirdLoginButton0.setBackgroundImage(UIImage(named: "resource/boot/third_wechat"), for: .normal)
        thirdLoginButton1.tintColor = .clear
        thirdLoginButton1.setBackgroundImage(UIImage(named: "resource/boot/third_qq"), for: .normal)
        thirdLoginButton2.tintColor = .clear
        thirdLoginButton2.setBackgroundImage(UIImage(named: "resource/boot/third_weibo"), for: .normal)
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 检查邮箱是否合法
    fileprivate func isEmailLegal(emailString string: String?) -> Bool{
        //判断账号是否为空
        guard let account: String = string, !account.characters.isEmpty else {
            tipLabel.text = ""//"请填写邮箱"
            return false
        }
        
        //判断账号是否合法
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = Regex(mailPattern)
        let maybeMailAddress = account
        guard matcher.match(input: maybeMailAddress) else{
            tipLabel.text = "输入邮箱作为登录账号"
            return false
        }
        
        tipLabel.text = ""
        
        return true
    }
    
    //MARK:- 检查密码是否合法
    fileprivate func isPasswordLegal(passwordString string: String?) -> Bool{
        //判断密码是否为空
        guard let password: String = passwordTextField.text, !password.characters.isEmpty else{
            showButton.isHidden = true
            tipLabel.text = ""//"密码不能为空"
            return false
        }
        showButton.isHidden = false
        guard  password.characters.count >= passwordMinLength else {
            tipLabel.text = "密码长度为\(passwordMinLength)~\(passwordMaxLength)之间"
            return false
        }
        tipLabel.text = ""
        return true
    }
    
    //MARK:- 返回上一层
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 点击登录
    @IBAction func login(_ sender: UIButton) {
        
        accountSeparatorLine.backgroundColor = separatorColor
        passwordSeparatorLine.backgroundColor = separatorColor
        accountTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        guard isEmailLegal(emailString: accountTextField.text) else {
            return
        }
        
        guard let account = accountTextField.text else {
            return
        }
        
        guard isPasswordLegal(passwordString: passwordTextField.text) else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
                
        //监测网络
        guard isNetworkEnable() else {
            return
        }
        
        //loading视图
        beginLoading()
        
        //登录
        ACAccountManager.login(withUserInfo: accountTextField.text!, password: passwordTextField.text){
            userinfo, error in
            
            DispatchQueue.main.async {
                self.endLoading()       //停止loading
                if let err = error {
                    debugPrint("<login error> userinfo: \(String(describing: userinfo)), \(err)")
                    self.tipLabel.text = "登录信息错误"
                    let alert = UIAlertController(title: "测试登录错误", message: "\(err)", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "关闭", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                debugPrint("<login success> userinfo: \(String(describing: userinfo)), error: nil")
                
                userDefaults.set(account, forKey: "account")
                userDefaults.set(password, forKey: "password")
                
                //登录到通知与提醒页面 判断
                let notificationSettingTypes = UIApplication.shared.currentUserNotificationSettings?.types
                let isAlreadyRequestAppleHealth = userDefaults.bool(forKey: "applehealth")
                let locationStatus = CLLocationManager.authorizationStatus()
                let isCallNotified = userDefaults.bool(forKey: "callnotified")
                guard notificationSettingTypes?.rawValue != 0 && isAlreadyRequestAppleHealth && (locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways) && isCallNotified else{
                    if let notifyNavigationController = UIStoryboard(name: "Notify", bundle: Bundle.main).instantiateViewController(withIdentifier: "notifyroot") as? UINavigationController{
                        self.present(notifyNavigationController, animated: true, completion: nil)
                        return
                    }
                    return
                }
                
                //跳转到主页
                let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
                self.present(rootTBC, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- 第三方登录
    @IBAction func thirdLogin(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 0 {
            //0: wechat
        }else if tag == 1{
            //1: qq
        }else if tag == 2{
            //2: weibo
        }
    }
    
    //MARK:- 显示与隐藏密码
    @IBAction func displayPassword(_ sender: UIButton) {
        isShowPassword = !isShowPassword
        sender.isSelected = isShowPassword
    }
    
    //MARK:- 忘记密码
    @IBAction func forgetPassword(_ sender: UIButton) {
        
    }
    
    //MARK:- 点击事件 回收键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accountSeparatorLine.backgroundColor = separatorColor
        passwordSeparatorLine.backgroundColor = separatorColor
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //MARK:- 复制判断
    @IBAction func valueChanged(_ sender: UITextField) {
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
    
    //MARK:- 编辑结束
    @IBAction func editingChanged(_ sender: UITextField) {
        setDoneButtonEnable()
    }
    
    //MARK:- 检查登录或注册按钮是否可选
    fileprivate func setDoneButtonEnable(){
        loginButton.isEnabled = isEmailLegal(emailString: accountTextField.text) && isPasswordLegal(passwordString: passwordTextField.text)
    }
}

//MARK:- textfield delegate
extension BootLoginVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
            accountSeparatorLine.backgroundColor = defaut_color
            passwordSeparatorLine.backgroundColor = separatorColor
        }else if textField == passwordTextField{
            accountSeparatorLine.backgroundColor = separatorColor
            passwordSeparatorLine.backgroundColor = defaut_color
        }
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            passwordTextField.becomeFirstResponder()
        }else if textField.tag == 1{
            textField.resignFirstResponder()
            login(loginButton)
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
            self.lowNiavigation.transform = keyboardTransform
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
            self.lowNiavigation.transform = keyboardTransform
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
        
        var maxLenght: Int
        if textField.tag == 0{
            maxLenght = accountMaxLength
        }else {
            maxLenght = passwordMaxLength
        }
        
        if existedLength! - selectedLength + replaceLength > maxLenght{
            return false
        }
        
        return true
    }
}

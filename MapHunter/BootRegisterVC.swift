//
//  BootRegisterVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/7.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
import AngelFit
class BootRegisterVC: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accountSeparatorLine: UIView!        //线->账号
    @IBOutlet weak var verificationSeparatorLine: UIView!   //线->验证码
    @IBOutlet weak var passwordSeparatorLine: UIView!       //线->密码
    @IBOutlet weak var verificationButton: UIButton!    //获取验证码按钮
    @IBOutlet weak var registerButton: UIButton!        //注册按钮
    @IBOutlet weak var tipLabel: UILabel!               //提示标签
    @IBOutlet weak var backButton: UIButton!            //返回按钮
    @IBOutlet weak var lowNavigation: UIView!           //底部导航视图
    @IBOutlet weak var showButton: UIButton!            //显示密码按钮
    @IBOutlet weak var agreementButton: UIButton!       //同意按钮
    @IBOutlet weak var contentButton: UIButton!         //条款按钮
    @IBOutlet weak var loginButton: UIButton!           //登录按钮
    @IBOutlet weak var confirmLabel: UILabel!           //确认文本
    
    //头像
    @IBOutlet weak var headImageView: UIImageView!      //头像图片
    
    fileprivate let passwordMinLength = 6           //密码最小长度
    fileprivate let passwordMaxLength = 20          //密码最大长度
    fileprivate let verifyLenght = 6                //验证码长度
    fileprivate let accountMinLength = 4            //账号最小长度
    fileprivate let accountMaxLength = 50           //账号最大长度
    
    fileprivate let networkHandler = NetworkHandler.share()
    
    private var mailAddress: String?                //存储合法邮箱地址
    
    fileprivate var headImage: UIImage?{
        didSet{
            headImageView.image = headImage
        }
    }
    
    private var tap: UITapGestureRecognizer?
    
    //是否显示密码
    fileprivate var isShowPassword = false{
        didSet{
            passwordTextField.isSecureTextEntry = !isShowPassword
        }
    }
    
    //验证倒计时label
    private lazy var countDownLabel: UILabel? = {
        let frame = CGRect(x: self.verificationButton.frame.origin.x, y: self.verificationButton.frame.origin.y - 4, width: self.verificationButton.frame.width, height: 12)
        let label: UILabel = UILabel(frame: frame)
        label.textAlignment = .center
        label.font = fontSmall
        label.textColor = defaut_color
        return label
    }()
    
    //MARK:- 定时器
    fileprivate var timer: DispatchSourceTimer?
    private var stepTime: DispatchTimeInterval = .seconds(1)
    
    //MARK:- 秒数
    private var maxCountSecond = 30
    private var countSeconds = 30{
        didSet{
            countDownLabel?.text = "\(countSeconds)"
            if countSeconds < 0{
                verificationButton.isEnabled = true
                countDownLabel?.removeFromSuperview()
            }else if countSeconds == maxCountSecond{
                if let label = countDownLabel{
                    verificationButton.isEnabled = false
                    view.addSubview(label)
                }
            }
        }
    }
    
    //MARK:- init *********************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private var bottomImageView: UIImageView?       //底部图片
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //手动添加背景图片
        if bottomImageView == nil{            
            if let originImage = UIImage(named: "resource/boot/bg_bottom"){
                let originSize = originImage.size
                let imageSize = CGSize(width: view_size.width, height: view_size.width * originSize.height / originSize.width)
                let bottomImage = originImage.transfromImage(size: imageSize)
                let lowNavigationHeight: CGFloat = 49
                bottomImageView = UIImageView(frame: CGRect(x: 0,
                                                            y: view.frame.height - lowNavigationHeight - imageSize.height,
                                                            width: imageSize.width,
                                                            height: imageSize.height))
                bottomImageView?.image = bottomImage
                view.insertSubview(bottomImageView!, belowSubview: lowNavigation)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        verificationTextField.placeholder = "输入验证码"
        accountSeparatorLine.backgroundColor = separatorColor
        verificationSeparatorLine.backgroundColor = separatorColor
        passwordSeparatorLine.backgroundColor = separatorColor
        loginButton.setTitleColor(defaut_color, for: .normal)
        loginButton.titleLabel?.font = fontSmall
        registerButton.setTitleColor(defaut_color, for: .normal)
        registerButton.setTitleColor(.lightGray, for: .disabled)
        registerButton.isEnabled = false
        contentButton.setTitleColor(default_color2, for: .normal)
        contentButton.titleLabel?.font = fontSmall
        confirmLabel.font = fontSmall
        confirmLabel.textColor = wordColor
        backButton.setImage(UIImage(named: "resource/scan/back")?.transfromImage(size: CGSize(width: 17, height: 17)), for: .normal)
        tipLabel.text = ""
        tipLabel.font = fontSmall
        tipLabel.textColor = defaut_color
        verificationButton.setTitleColor(defaut_color, for: UIControlState.normal)
        verificationButton.setTitleColor(.lightGray, for: .disabled)
        verificationButton.isEnabled = isEmailLegal(emailString: accountTextField.text)
        showButton.tintColor = .clear
        showButton.setBackgroundImage(UIImage(named: "resource/boot/show_on")?.transfromImage(size: CGSize(width: 24, height: 24)), for: .normal)
        showButton.setBackgroundImage(UIImage(named: "resource/boot/show_off")?.transfromImage(size: CGSize(width: 24, height: 24)), for: .selected)
        showButton.isHidden = true
        agreementButton.tintColor = .clear
        agreementButton.setBackgroundImage(UIImage(named: "resource/boot/agreement_off"), for: .normal)
        agreementButton.setBackgroundImage(UIImage(named: "resource/boot/agreement_on"), for: .selected)
        
        headImage = UIImage(named: "resource/boot/camera")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //设置头像遮罩
        let path = UIBezierPath(ovalIn: headImageView.bounds)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        headImageView.layer.mask = maskLayer
        
        let ovalLayer = CAShapeLayer()
        ovalLayer.path = path.cgPath
        ovalLayer.fillColor = nil
        ovalLayer.lineWidth = 4
        ovalLayer.strokeColor = timeColor.cgColor
        headImageView.layer.addSublayer(ovalLayer)
        
        //为头像添加点击事件
        if tap == nil{
            tap = UITapGestureRecognizer(target: self, action: #selector(tapHeadImageView(recognizer:)))
            tap?.numberOfTapsRequired = 1
            tap?.numberOfTouchesRequired = 1
            headImageView.addGestureRecognizer(tap!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //移除定时器
        timer?.cancel()
        
        if let t = tap{
            headImageView.removeGestureRecognizer(t)
            tap = nil
        }
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 检查邮箱是否合法
    fileprivate func isEmailLegal(emailString string: String?) -> Bool{
        //判断账号是否为空
        guard let account: String = string, !account.characters.isEmpty else {
            tipLabel.text = " "//"请填写邮箱"
            return false
        }
        
        //判断账号是否合法
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = Regex(mailPattern)
        let maybeMailAddress = account
        guard matcher.match(input: maybeMailAddress) else{
            tipLabel.text = "输入邮箱作为登录账号"
            verificationButton.isEnabled = false
            return false
        }
        
        tipLabel.text = " "
        if countSeconds <= 0 {
            verificationButton.isEnabled = true
        }
        return true
    }
    
    //MARK:- 检查密码是否合法
    fileprivate func isPasswordLegal(passwordString string: String?) -> Bool{
        //判断密码是否为空
        guard let password: String = passwordTextField.text, !password.characters.isEmpty else{
            showButton.isHidden = true
            tipLabel.text = " "//"密码不能为空"
            return false
        }
        showButton.isHidden = false
        guard  password.characters.count >= passwordMinLength else {
            tipLabel.text = "密码长度为\(passwordMinLength)~\(passwordMaxLength)之间"
            return false
        }
        tipLabel.text = " "
        return true
    }
    
    //MARK:- 检查验证码是否合法
    fileprivate func isVerifyCodeLegal(verifyCode string: String?) -> Bool{
        //判断验证码是否为空
        guard let verifyCode = verificationTextField.text, verifyCode.characters.count == verifyLenght else {
            tipLabel.text = "请输入六位验证码"
            return false
        }
        tipLabel.text = " "
        return true
    }
    
    //MARK:- 点击获取验证码
    @IBAction func getVerificationCode(_ sender: UIButton){
        accountTextField.endEditing(true)
        verificationTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        if isEmailLegal(emailString: accountTextField.text) {            
            //获取验证码
            let verificationCodeParam = NWHUserVerificationCodeParam()
            verificationCodeParam.email = accountTextField.text
            networkHandler.user.getVerificationCode(withParam: verificationCodeParam, closure: {
                resultCode, message, data in
                DispatchQueue.main.async {
                    if resultCode == ResultCode.success {
                        self.tipLabel.text = "验证码已发送，请在邮箱中查找"
                        debugPrint("<verify code> 发送验证码成功")
                        
                        //倒计时
                        self.countDown(flag: true)
                        
                        //存储该邮箱
                        self.mailAddress = self.accountTextField.text
                    }else {
                        debugPrint("<verify code> 发送验证码错误 message: " + message)
                        self.tipLabel.text = message
                    }
                }
            })
        }
    }
    
    //MARK:- 开始或暂停倒计时
    private func countDown(flag: Bool){
        if flag {
            //开始计时
            self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: .main)
            self.timer?.scheduleRepeating(deadline: .now(), interval: self.stepTime)
            self.timer?.setEventHandler{self.countSec()}
            self.timer?.resume()        //启动定时器
            
            countSeconds = maxCountSecond
        }
    }
    
    private func countSec(){
        countSeconds -= 1
    }
    
    //MARK:- 点击勾选条款
    @IBAction func accept(_ sender: UIButton) {
        agreementButton.isSelected = !agreementButton.isSelected
        setDoneButtonEnable()
    }
    
    //MARK:- 返回上一级
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 点击注册
    @IBAction func register(_ sender: UIButton) {
        
        accountTextField.endEditing(true)
        verificationTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        //判断账号是否为空
        guard let account: String = mailAddress else{
            tipLabel.text = "点击获取验证码"
            return
        }
        
        guard account == accountTextField.text else {
            tipLabel.text = "该邮箱未获取验证码"
            return
        }
        
        //判断密码是否为空
        guard let password = passwordTextField.text else {
            return
        }
        guard isPasswordLegal(passwordString: password) else {
            return
        }
        
        //判断验证码是否为空
        guard let verifyCode = verificationTextField.text else {
            return
        }
        guard isVerifyCodeLegal(verifyCode: verifyCode) else {
            return
        }
        
        //判断是否勾选点击勾选条款
        guard agreementButton.isSelected else {
            tipLabel.text = "需同意FunSport使用条款"
            return
        }
        
        //监测网络是否可用
        guard isNetworkEnable() else {
            return
        }
        
        //loading视图
        beginLoading()
        
        //注册
        let userRegisterParam = NWHUserRegisterParam()
        userRegisterParam.userId = account
        userRegisterParam.password = password
        userRegisterParam.confirm = verifyCode
        networkHandler.user.register(withParam: userRegisterParam, closure: {
            resultCode, message, data in
            DispatchQueue.main.async {
                self.endLoading()
                
                if resultCode == ResultCode.success {
                    debugPrint("<register success> message: " + message)
                    
                    self.tipLabel.text = message
                    
                    //注册成功并载入登录
                    userDefaults.set(account, forKey: "account")
                    userDefaults.set(password, forKey: "password")
                    
                    //上传个人信息
                    self.beginLoading(byTitle: "正在初始化个人信息")
                    let userUpdateParam = NWHUserUpdateParam()
                    userUpdateParam.userId = account
                    userUpdateParam.password = password
                    userUpdateParam.email = account
                    userUpdateParam.weixin = nil
                    userUpdateParam.mobile = nil
                    userUpdateParam.showName = nil
                    userUpdateParam.heightCM = UInt(userDefaults.integer(forKey: "height"))
                    userUpdateParam.weightG = UInt(userDefaults.integer(forKey: "weight"))
                    userUpdateParam.genderBoy = userDefaults.integer(forKey: "gender") == 1
                    userUpdateParam.birthday = Date(timeInterval: -userDefaults.double(forKey: "offsetdays") * 60 * 60 * 24, since: Date())
                    self.networkHandler.user.update(withParam: userUpdateParam, closure: {
                        resultCode, message, data in
                        DispatchQueue.main.async {
                            self.endLoading()
                          
                            print("<更新个人信息> resultCode: \(resultCode), message: " + message + ", data: \(String(describing: data))")
                            
                            //登录到通知与提醒页面 判断
                            //let notificationSettingTypes = UIApplication.shared.currentUserNotificationSettings?.types
                            let isNotification = userDefaults.bool(forKey: "notification")
                            let isAlreadyRequestAppleHealth = userDefaults.bool(forKey: "applehealth")
                            let locationStatus = CLLocationManager.authorizationStatus()
                            let isCallNotified = userDefaults.bool(forKey: "callnotified")
                            guard isNotification && isAlreadyRequestAppleHealth && !(locationStatus == .notDetermined) && isCallNotified else{
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
                    })
                    
                    
                }else {
                    self.tipLabel.text = message
                }
            }
        })
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
        isShowPassword = !isShowPassword
        sender.isSelected = isShowPassword
    }
    
    //MARK:- 点击查看使用条款
    @IBAction func checkAgreement(_ sender: UIButton) {
        
    }
    
    //MARK:- 输入判断
    @IBAction func valueChanged(_ sender: UITextField) {
        guard sender.text != nil else{
            return
        }
        
        //根据邮箱是否非法判断是否显示获取验证码按钮
        verificationButton.isEnabled = isEmailLegal(emailString: accountTextField.text)
        
        //判断账号或密码
        var maxLength: Int                      //输入最大长度
        if sender.tag == 0{
            maxLength = accountMaxLength        //取账号最大长度
        }else if sender.tag == 1{
            maxLength = verifyLenght            //验证码长度
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
    
    @IBAction func editingChanged(_ sender: UITextField) {
        setDoneButtonEnable()
    }
    
    //MARK:- 页面点击事件 回收键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accountSeparatorLine.backgroundColor = separatorColor
        verificationSeparatorLine.backgroundColor = separatorColor
        passwordSeparatorLine.backgroundColor = separatorColor
        accountTextField.resignFirstResponder()
        verificationTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //MARK:- 头像点击事件
    @objc private func tapHeadImageView(recognizer: UITapGestureRecognizer){
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel){
            action in
        }
        alertController.addAction(cancelAction)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default){
            action in
            self.selectPhotoFromCamera()
        }
        alertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "从手机相册选择", style: .default){
            action in
            self.selectPhotoFromLibrary()
        }
        alertController.addAction(libraryAction)
        
        alertController.setBlackTextColor()
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- 检查登录或注册按钮是否可选
    fileprivate func setDoneButtonEnable(){
        registerButton.isEnabled = isEmailLegal(emailString: accountTextField.text) && isPasswordLegal(passwordString: passwordTextField.text) && isVerifyCodeLegal(verifyCode: verificationTextField.text) && agreementButton.isSelected
    }
}

//MARK:- textfield delegate
extension BootRegisterVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
            accountSeparatorLine.backgroundColor = defaut_color
            verificationSeparatorLine.backgroundColor = separatorColor
            passwordSeparatorLine.backgroundColor = separatorColor
        }else if textField == verificationTextField{
            accountSeparatorLine.backgroundColor = separatorColor
            verificationSeparatorLine.backgroundColor = defaut_color
            passwordSeparatorLine.backgroundColor = separatorColor
        }else if textField == passwordTextField{
            accountSeparatorLine.backgroundColor = separatorColor
            verificationSeparatorLine.backgroundColor = separatorColor
            passwordSeparatorLine.backgroundColor = defaut_color
        }
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        accountSeparatorLine.backgroundColor = separatorColor
        if textField.tag == 0{
            verificationSeparatorLine.backgroundColor = defaut_color
            passwordSeparatorLine.backgroundColor = separatorColor
            verificationTextField.becomeFirstResponder()
        }else if textField.tag == 1{
            verificationSeparatorLine.backgroundColor = separatorColor
            passwordSeparatorLine.backgroundColor = defaut_color
            passwordTextField.becomeFirstResponder()
        }else if textField.tag == 2{
            verificationSeparatorLine.backgroundColor = separatorColor
            passwordSeparatorLine.backgroundColor = separatorColor
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
            //self.view.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    //输入判断
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existedLength = textField.text?.lengthOfBytes(using: .utf8)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytes(using: .utf8)
        var maxLength: Int
        if textField.tag == 0{
            maxLength = accountMaxLength
            if var accountString = accountTextField.text{
                let startIndex = accountString.index(accountString.startIndex, offsetBy: range.location)
                let endIndex = accountString.index(accountString.startIndex, offsetBy: range.location + range.length)
                let replaceRange = Range(startIndex..<endIndex)
                accountString = accountString.replacingCharacters(in: replaceRange, with: string)
                verificationButton.isEnabled = isEmailLegal(emailString: accountString)
            }
        }else if textField.tag == 1{
            maxLength = verifyLenght
        }else {
            maxLength = passwordMaxLength
        }
        
        
        if existedLength! - selectedLength + replaceLength > maxLength{
            return false
        }
        return true
    }
}

//MARK:- 头像操作
extension BootRegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK:从照片库中挑选图片
    fileprivate func selectPhotoFromLibrary(){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else{
            let alertController = UIAlertController(title: "拍照", message: "相机获取图片失效", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .currentContext
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:从相机中拍摄图片
    fileprivate func selectPhotoFromCamera(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else{
            let alertController = UIAlertController(title: "相册", message: "获取相册图片失效", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = UIImagePickerControllerSourceType.camera
        cameraPicker.modalPresentationStyle = .currentContext
        cameraPicker.allowsEditing = true
        //        cameraPicker.cameraOverlayView = ? 覆盖在相机上
        cameraPicker.showsCameraControls = true
        cameraPicker.cameraDevice = .front
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.headImage = image
        picker.dismiss(animated: true){}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true){}
    }
}

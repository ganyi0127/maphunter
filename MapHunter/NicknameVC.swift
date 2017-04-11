//
//  NicknameVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/3/30.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class NicknameVC: UIViewController {
    
    fileprivate var nameTextField: UITextField!
    fileprivate var saveButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = timeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(save(sender:)))
//        saveButton?.tintColor = wordColor
//        self.navigationItem.rightBarButtonItem = saveButton

    }
    
    private func config(){

        let textfieldFrame = CGRect(x: 0, y: 64, width: view_size.width, height: 44)
        nameTextField = UITextField(frame: textfieldFrame)
        nameTextField.delegate = self
        nameTextField.backgroundColor = .white
        nameTextField.autocapitalizationType = .none
        nameTextField.autocorrectionType = .no
        nameTextField.borderStyle = .none
        nameTextField.clearButtonMode = .always
        nameTextField.text = "gan"
        nameTextField.keyboardType = .default
        nameTextField.returnKeyType = .done
        nameTextField.addTarget(self, action: #selector(editingChanged(sender:)), for: .valueChanged)
        view.addSubview(nameTextField)
    }
    
    
    //输入判断
    @objc func editingChanged(sender: UITextField) {
        guard let _:String = sender.text else{
            return
        }
        
        if sender.text == "gan" {
            saveButton?.tintColor = wordColor
        }else{
            saveButton?.tintColor = .gray
        }
        
        //限制字符数
        if (sender.text?.lengthOfBytes(using: String.Encoding.utf8))! > 32{
            while sender.text!.lengthOfBytes(using: String.Encoding.utf8) > 32 {
                
                let endIndex = sender.text!.index(sender.text!.endIndex, offsetBy: -1)
                let range = Range(sender.text!.startIndex..<endIndex)
                sender.text = sender.text!.substring(with: range)
            }
        }
    }
    
    //MARK:保存
    @objc func save(sender: UIBarButtonItem) {
        
        guard let text = nameTextField.text else{
            return
        }
        
        if text.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            do{
                //存数据库
                
                //返回到上一层页面
                _ = navigationController?.popViewController(animated: true)
            }catch let error{
                print("CoreData保存昵称错误: \(error)")
            }
        }
    }
    
}

extension NicknameVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    //复制判断
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let existedLength = textField.text?.lengthOfBytes(using: String.Encoding.utf8)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytes(using: String.Encoding.utf8)
        if existedLength! - selectedLength + replaceLength > 10{
            return false
        }
        return true
    }
}

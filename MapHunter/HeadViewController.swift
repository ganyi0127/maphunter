//
//  HeadViewController.swift
//  MapHunter
//
//  Created by YiGan on 21/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class HeadViewController: UIViewController {
    
    fileprivate var image: UIImage?
    fileprivate var imageView: UIImageView?
    
    init(image: UIImage?){
        super.init(nibName: nil, bundle: nil)
        
        self.image = image
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigation(hidden: true)
    }
    
    private func config(){
        view.backgroundColor = .black
        navigationController?.setNavigation(hidden: true)
        
        let itemButton = UIBarButtonItem(title: "...", style: .done, target: self, action: #selector(changeImage(sender:)))
        navigationItem.rightBarButtonItem = itemButton
    }
    
    private func createContents(){
        
        if let img = image{
            let imageViewFrame = CGRect(x: 0, y: (view_size.height - view_size.width) / 2, width: view_size.width, height: view_size.width)
            imageView = UIImageView(frame: imageViewFrame)
            imageView?.image = img
            view.addSubview(imageView!)
            
            //添加手势
            imageView?.isUserInteractionEnabled = true
            let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(recognizer:)))
            longpress.minimumPressDuration = 0.2
            imageView?.addGestureRecognizer(longpress)
        }
    }
    
    //MARK:- 修改相片
    @objc private func changeImage(sender: UIBarButtonItem){
        
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
        
        let saveAction = UIAlertAction(title: "保存图片", style: .default){
            action in
            self.saveImage(self.image)
        }
        alertController.addAction(saveAction)

        alertController.setBlackTextColor()
        present(alertController, animated: true, completion: nil)
    }
    
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
    
    //MARK:- 长按
    @objc private func longPress(recognizer: UILongPressGestureRecognizer){
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "保存图片", style: .default){
            action in
            self.saveImage(self.image)
        }
        alertController.addAction(saveAction)
        
        alertController.setBlackTextColor()
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- 保存图片
    private func saveImage(_ saveImage: UIImage?){
        guard let img = saveImage else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
    }
    
    @objc private func saveComplete(){

        let alertController = UIAlertController(title: "", message: "已保存到本地相册", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK:照片库delegate
extension HeadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        imageView?.image = image
        picker.dismiss(animated: true){}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true){}
    }
}

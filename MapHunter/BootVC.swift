//
//  BootVC.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/6.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import UIKit
class BootVC: UIViewController {
    @IBOutlet weak var backCollectionView: UICollectionView!
    @IBOutlet weak var frontCollectionView: UICollectionView!
    @IBOutlet weak var quickLogin: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate let backImages = [UIImage(named: "resource/boot/main/0_1")?.transfromImage(size: view_size),
                                  UIImage(named: "resource/boot/main/1_1")?.transfromImage(size: view_size),
                                  UIImage(named: "resource/boot/main/2_1")?.transfromImage(size: view_size),
                                  UIImage(named: "resource/boot/main/3_1")?.transfromImage(size: view_size)]
    fileprivate let frontImages = [UIImage(named: "resource/boot/main/0_2")?.transfromImage(size: view_size),
                                   UIImage(named: "resource/boot/main/1_2")?.transfromImage(size: view_size),
                                   UIImage(named: "resource/boot/main/2_2")?.transfromImage(size: view_size),
                                   UIImage(named: "resource/boot/main/3_2")?.transfromImage(size: view_size)]
    
    
    //MARK:- init****************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //隐藏导航栏
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //添加创建并添加本地通知
        LocalNotification.addNotification(withMessage: "its a test local notification!!!")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //显示导航栏
        navigationController?.isNavigationBarHidden = false
    }
    
    private func config(){
        //注册collection cell
        (0..<4).forEach{
            row in
            backCollectionView.register(BootCell.self, forCellWithReuseIdentifier: "\(row)_0")
            frontCollectionView.register(BootCell.self, forCellWithReuseIdentifier: "\(row)_1")
        }
        backCollectionView.backgroundColor = .clear
        backCollectionView.layer.zPosition = 1
        frontCollectionView.backgroundColor = .clear
        frontCollectionView.layer.zPosition = 3
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        quickLogin.setTitle("立即加入", for: .normal)
        quickLogin.setTitleColor(.white, for: .normal)
        quickLogin.tintColor = .white
        quickLogin.backgroundColor = .clear
        quickLogin.setBackgroundImage(UIImage(named: "resource/boot/main/botton_normal"), for: .normal)
        quickLogin.setBackgroundImage(UIImage(named: "resource/boot/main/botton_highlighted"), for: .highlighted)
        quickLogin.layer.zPosition = 4
        
        login.setTitle("登录", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.tintColor = .white
        login.backgroundColor = .clear
        login.setBackgroundImage(UIImage(named: "resource/boot/main/botton_normal"), for: .normal)
        login.setBackgroundImage(UIImage(named: "resource/boot/main/botton_highlighted"), for: .highlighted)
        login.layer.zPosition = 4
        
        pageControl.layer.zPosition = 4
    }
    
    private func createContents(){
        
        //添加背景圆圈
        if let originImage = UIImage(named: "resource/boot/main/bottom"){
            let imageSize = CGSize(width: view_size.width, height: view_size.width * originImage.size.height / originImage.size.width)
            let image = originImage.transfromImage(size: imageSize)
            let bottomImageView = UIImageView(image: image)
            bottomImageView.layer.zPosition = 2
            view.addSubview(bottomImageView)
        }
    }
    
    @IBAction func click(_ sender: UIButton) {
        if sender.tag == 0 {
            //快速登陆
        }else if sender.tag == 1{
            //登陆
        }
    }
    
    //MARK:- 登录主页面
    @IBAction func loadingMainMenu(_ sender: UIButton) {
        //登陆主页
        let rootTBC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! RootTBC
        present(rootTBC, animated: true, completion: nil)
    }
}

//Collection delegate
extension BootVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let tag = collectionView.tag
        let identifier = "\(row)_\(tag)"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if cell.contentView.subviews.isEmpty {
            var image: UIImage?
            if tag == 0 {
                image = backImages[row]
            }else{
                image = frontImages[row]
            }
            let backImageView = UIImageView(frame: cell.bounds)
            backImageView.image = image
            cell.contentView.addSubview(backImageView)
        }
//        pageControl.currentPage = row
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(view_size.width) //indexPath.row
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1 {
            backCollectionView.contentOffset = scrollView.contentOffset
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //返回等同于窗口大小的尺寸
        return view_size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero//UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
    //
    //    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

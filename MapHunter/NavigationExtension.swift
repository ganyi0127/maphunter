//
//  NavigationExtension.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import CoreBluetooth
import AngelFit
//手环图标
//let linkBarButton = ItemButton(buttonType: .link)

//绑定状态
var bandItem: UIBarButtonItem?
enum GlobalBandState{
    case normal
    case binded
    case disConnected
    case batteryLow
}
var globalBandImageMap:[GlobalBandState: UIImage?]{
    get{
        let normalImage = UIImage(named: "resource/binding_state_0")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
        let bindedImage = UIImage(named: "resource/binding_state_1")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
        let disconnectedImage = UIImage(named: "resource/binding_state_2")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
        let batteryLowImage = UIImage(named: "resource/binding_state_3")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
        return [GlobalBandState.normal: normalImage, GlobalBandState.binded: bindedImage, GlobalBandState.disConnected: disconnectedImage, GlobalBandState.batteryLow: batteryLowImage]
    }
}

extension UINavigationController: UINavigationControllerDelegate{
    
    open override func awakeFromNib() {
        
        delegate = self
        
        //初始化存储navigation高度
        if navigation_height == nil{
            navigation_height = navigationBar.frame.height
        }
        
        //设置title
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: font_name, size: 17)!,
                                             NSForegroundColorAttributeName: wordColor]
        
        
        navigationBar.backgroundColor = defaultColor
        
        let image = UIImage(named: "resource/navigation_back")?.transfromImage(size: CGSize(width: view_size.width, height: navigation_height! + 64))
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    //切换界面时调用_手环按钮
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //判断是否为根视图
        if viewControllers.count == 1{
            
            navigationBar.tintColor = wordColor
            
            if navigationItem.leftBarButtonItem == nil {
                if viewController.isKind(of: StateVC.self){
                    if viewController.navigationItem.leftBarButtonItem == nil{
//                        viewController.navigationItem.leftBarButtonItem = linkBarButton
                        //手环状态视图
                        let peripheral = PeripheralManager.share().currentPeripheral
                        let image = peripheral?.state == CBPeripheralState.connected ? globalBandImageMap[.normal]! : globalBandImageMap[.disConnected]!
                        let imageSize = image?.size
                        let imageFrame = CGRect(origin: .zero, size: imageSize!)
                        let imageView = UIImageView(frame: imageFrame)
                        imageView.image = image
//                        let tap = UITapGestureRecognizer(target: (viewController as! StateVC).topView, action: #selector((viewController as! StateVC).topView.clickCalendar))
//                        tap.numberOfTapsRequired = 1
//                        tap.numberOfTouchesRequired = 1
//                        imageView.addGestureRecognizer(tap)
                        if bandItem == nil{
                            bandItem = UIBarButtonItem(customView: imageView)
                        }
                        viewController.navigationItem.leftBarButtonItem = bandItem!
                    }
                }
            }
            
            if navigationItem.rightBarButtonItem == nil {
                if viewController.isKind(of: StateVC.self){
                    //头像
                    let image = UIImage(named: "resource/me/me_head_boy")
                    let imageSize = CGSize(width: navigation_height! * 0.98, height: navigation_height! * 0.98)
                    let imageFrame = CGRect(origin: .zero, size: imageSize)
                    let imageView = UIImageView(frame: imageFrame)
                    imageView.image = image
                    let maskLayer = CAShapeLayer()
                    maskLayer.path = UIBezierPath(ovalIn: imageFrame).cgPath
                    imageView.layer.mask = maskLayer
                    let tap = UITapGestureRecognizer(target: (viewController as! StateVC).topView, action: #selector((viewController as! StateVC).topView.clickCalendar))
                    tap.numberOfTapsRequired = 1
                    tap.numberOfTouchesRequired = 1
                    imageView.addGestureRecognizer(tap)
                    let heardItem = UIBarButtonItem(customView: imageView)
                    viewController.navigationItem.rightBarButtonItem = heardItem
                }else if viewController.isKind(of: MeVC.self){
                    //个人视图
                    let image = UIImage(named: "resource/me/me_setting")
                    let imageSize = CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6)
                    let calenderBarButton = UIBarButtonItem(image: image?.transfromImage(size: imageSize), style: .done, target: viewController, action: #selector(MeVC.clickSetting(sender:)))
                    viewController.navigationItem.rightBarButtonItem = calenderBarButton
                }
            }
            
            //设置显示navigation
            if viewController.isKind(of: FunVC.self) || viewController.isKind(of: MeVC.self){
                //地图页面置透明
                setNavigation(hidden: true)
                
            }else{
                //设置为不透明
                setNavigation(hidden: false)
                
                navigationBar.topItem?.title = "" //"FunSport"
            }
            
            //显示tabbar
            setTabbar(hidden: false)
        }else{
            
//            if viewController.isKind(of: DetailViewController.self) {
//                navigationBar.tintColor = .white
//            }else{
//                navigationBar.tintColor = wordColor
//            }
            
            navigationItem.leftBarButtonItem = nil
            
            //隐藏tabbar
            setTabbar(hidden: true)
        }
    }
    
    //MARK:- 控制navigation显示与隐藏
    public func setNavigation(hidden flag: Bool){
        var image: UIImage!
        if flag {
            //设置navigation透明
            image = UIImage(named: "resource/navigation_alpha")
            navigationBar.backgroundColor = nil
        }else{
            //设置为不透明
            image = UIImage(named: "resource/navigation_back")?.transfromImage(size: CGSize(width: view_size.width, height: navigation_height! + 64))
            navigationBar.backgroundColor = .clear
        }
        navigationBar.setBackgroundImage(image, for: .default)
    }
    
    public func setNavigationOpacity(opacity flag: Bool){
        if flag{
            navigationBar.tintColor = subWordColor
            navigationBar.titleTextAttributes = [NSFontAttributeName: fontMiddle, NSForegroundColorAttributeName: subWordColor]
            navigationBar.setBackgroundImage(nil, for: .default)
            setNavigation(hidden: false)
        }else{
            navigationBar.tintColor = .white
            navigationBar.titleTextAttributes = [NSFontAttributeName: fontSmall, NSForegroundColorAttributeName: UIColor.white]
            setNavigation(hidden: true)
        }
    }
    
    //MARK:- 控制tabbar显示与隐藏
    public func setTabbar(hidden flag: Bool){
        
        guard var tabbarFrame = tabBarController?.tabBar.frame else {
            return
        }
        
        if flag {
            //隐藏tabbar
            if tabbarFrame.origin.y < view_size.height {
                
                let offsetY:CGFloat = tabbarFrame.height + view_size.width * 0.06
                let duration: TimeInterval = 0.2
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                    self.tabBarController?.tabBar.frame = tabbarFrame.offsetBy(dx: 0, dy: offsetY)
                }, completion: nil)
            }
        }else{
            //显示tabbar

            if tabbarFrame.origin.y >= view_size.height{
                
                tabbarFrame.origin.y = view_size.height - tabbarFrame.height
                let duration: TimeInterval = 0.2
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                    self.tabBarController?.tabBar.frame = tabbarFrame
                }, completion: nil)
            }
        }
    }
    
    //MARK:- 转场代理实现
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //模版
        if fromVC.isKind(of: StateVC.self) || toVC.isKind(of: StateVC.self) {
            
            if fromVC.isKind(of: TrackVC.self) || toVC.isKind(of: TrackVC.self) {
                return nil
            }
            
            if operation == .push{
                return StatePushController()
            }
            return StatePopController()
        }
        
        //头像点击
        if fromVC.isKind(of: MeVC.self) && toVC.isKind(of: MeInfo.self){
            let indexPath = IndexPath(row: 0, section: 0)
            let meVC = fromVC as! MeVC
            let cell = meVC.tableview.cellForRow(at: indexPath) as! MeCell1
            var startRect = cell.convert(cell.headImageView.frame, to: meVC.view)
            startRect.origin.y -= 64
            return StatePushController(startRect: startRect)
        }else if fromVC.isKind(of: MeInfo.self) && toVC.isKind(of: MeVC.self){
            let indexPath = IndexPath(row: 0, section: 0)
            let meVC = toVC as! MeVC
            let cell = meVC.tableview.cellForRow(at: indexPath) as! MeCell1
            var endRect = cell.convert(cell.headImageView.frame, to: meVC.view)
            endRect.origin.y -= 64
            return StatePopController(endRect: endRect)
        }
        
        //目标页面、体重编辑页面
        if fromVC.isKind(of: DetailViewController.self) && toVC.isKind(of: TargetSettingVC.self) {
            return BottomPushController()
        }else if fromVC.isKind(of: TargetSettingVC.self) && toVC.isKind(of: DetailViewController.self){
            return BottomPopController()
        }else if fromVC.isKind(of: DetailViewController.self) && toVC.isKind(of: WeightEditVC.self){
            return BottomPushController()
        }else if fromVC.isKind(of: WeightEditVC.self) && toVC.isKind(of: DetailViewController.self){
            return BottomPopController()
        }
        
        //介绍页面
        if fromVC.isKind(of: DetailViewController.self) && toVC.isKind(of: IntroduceVC.self){
            return MiddlePushController()
        }else if fromVC.isKind(of: IntroduceVC.self) && toVC.isKind(of: DetailViewController.self){
            return MiddlePopController()
        }
        
        return nil
    }
}


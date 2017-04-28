//
//  ItemButton.swift
//  MapHunter
//
//  Created by ganyi on 16/9/22.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
enum ItemButtomType{
    case link
}
enum LinkButtonState{
    case binded
    case connecting
    case disconnected
    case batteryLow
}
class ItemButton: UIBarButtonItem {
    
    //绑定状态图片
    private enum BandState{
        case normal
        case binded
        case disConnected
        case batteryLow
    }
    private var bandImageMap:[BandState: UIImage?]{
        get{
            let normalImage = UIImage(named: "resource/binding_state_0")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
            let bindedImage = UIImage(named: "resource/binding_state_1")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
            let disconnectedImage = UIImage(named: "resource/binding_state_2")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
            let batteryLowImage = UIImage(named: "resource/binding_state_3")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
            return [BandState.normal: normalImage, BandState.binded: bindedImage, BandState.disConnected: disconnectedImage, BandState.batteryLow: batteryLowImage]
        }
    }
    
    //当前button类型
    var buttonType:ItemButtomType?
    
    /*=====================================================*/
    init(buttonType type: ItemButtomType){
        super.init()
        
        buttonType = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(itemButton:) has not been implemented")
    }
    
    private func config(){

        style = .done
        
        switch buttonType! {
        case .link:
            image = (bandImageMap[.normal])!
        }
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 切换状态
    func setState(withLinkButtonState state: LinkButtonState){
        
        guard buttonType == .link else {
            return
        }
        
        switch state {
        case .binded:
            image = bandImageMap[BandState.binded]!
            _ = delay(4){
                self.image = self.bandImageMap[BandState.normal]!
            }
        case .connecting:            
            image = bandImageMap[BandState.normal]!
        case .disconnected:
            image = bandImageMap[BandState.disConnected]!
        case .batteryLow:
            image = bandImageMap[BandState.batteryLow]!
        }
    }
    
    private func getMatchedImage(originImage image: UIImage) -> UIImage?{
        
        let imageSize = CGSize(width: navigation_height! / 2, height: navigation_height! / 2)
        
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(origin: .zero, size: imageSize))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}

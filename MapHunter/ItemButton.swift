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
class ItemButton: UIBarButtonItem {
    
    //绑定状态图片
    private var bindingImageMap:[String: UIImage?]{
        get{
            
            let onImage = UIImage(named: "resource/binding_state_1")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
            let offImage = UIImage(named: "resource/binding_state_0")!.transfromImage(size: CGSize(width: navigation_height! * 0.6, height: navigation_height! * 0.6))
            return ["on": onImage, "off": offImage]
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
            image = (bindingImageMap["on"])!
        }
    }
    
    private func createContents(){
        
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

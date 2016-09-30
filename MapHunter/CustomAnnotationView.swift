//
//  CustomAnnotationView.swift
//  MapHunter
//
//  Created by ganyi on 16/9/26.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import UIKit
import MapKit
class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.annotation = annotation
    
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        canShowCallout = true   //显示标题
        calloutOffset = CGPoint(x: 0, y: -5)
        
        let leftButton = UIButton(type: UIButtonType.infoDark)
        leftButton.tag = 0
        leftCalloutAccessoryView = leftButton
        
        let rightButton = UIButton(type: .contactAdd)
        rightButton.tag = 1
        rightCalloutAccessoryView = rightButton

        var images = [UIImage]()
        
        let width = view_size.width / 10
        let imageSize = CGSize(width: width, height: width)
        UIGraphicsBeginImageContext(imageSize)
        
        (1..<9).forEach(){
            index in
            if let image = UIImage(named: "role_stay-\(index)"){
                
                image.draw(in: CGRect(origin: .zero, size: imageSize))
                
                if let result = UIGraphicsGetImageFromCurrentImageContext(){
                    images.append(result)
                }
            }
        }
        UIGraphicsEndImageContext()
        
        let animView = UIImageView(frame: CGRect(origin: CGPoint(x: -width / 2, y: -width / 2), size: imageSize))
        animView.animationImages = images
        animView.animationDuration = 1
        animView.animationRepeatCount = 0 //infinite
        animView.startAnimating()
        addSubview(animView)
        
    }
    
    private func createContents(){
        
    }
}

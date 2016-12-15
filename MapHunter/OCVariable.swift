//
//  OCVariable.swift
//  MapHunter
//
//  Created by YiGan on 09/12/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

import UIKit
class OCVariable: NSObject {
    
    var v_max: CGFloat = 20.0
    var v_min: CGFloat = 5.0
    
    static let __once = OCVariable()
    class func share() -> OCVariable {
        return __once
    }
}

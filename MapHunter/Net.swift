//
//  Net.swift
//  MapHunter
//
//  Created by ganyi on 2016/10/25.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
//请求类型
enum NetType:String{
    case coordinates = "coordinates"
    case mark = "marksprite"
}

private let localhost = "http://localhost:8080"
private let compWifi = "http://192.168.2.80:8080"

class Net{
    
    class func post(withNetType netType: NetType, params: [String : AnyObject], closure: @escaping (_ success: Bool, _ results: [String : AnyObject]?, _ reason: String?) -> ()){
        do{
            let requestData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let urlPath = localhost + "/" + netType.rawValue
            let url = URL(string: urlPath)
            
            var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestData
            
            let session = URLSession.shared
            let task = session.dataTask(with: request){
                data, response, error in
                
                //返回数据
                DispatchQueue.main.async(){
                    
                    if let err = error{
                        closure(false, nil, "请求错误:\(err)")
                        return
                    }
                    
                    guard let responseData = data else{
                        return
                    }

                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as! [String : AnyObject]
                        
                        if let flag = json["result"] as? Bool{
                            if flag{
                                closure(true, json["data"] as! [String : AnyObject]?, nil)
                            }else{
                                closure(false, nil, json["reason"] as! String?)
                            }
                        }
                        
                    }catch let jsonError{
                        print("responseError: \(jsonError)")
                    }
                    
                }
            }
            
            task.resume()
        }catch let error{
            print("netError: \(error)")
        }
    }
}

//
//  ExceptionHandler.swift
//  MapHunter
//
//  Created by ganyi on 2017/4/19.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
private var curPath: String?

func dataPath(_ index: Int) -> String {
    
    //获取当前日期
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let dateStr = formatter.string(from: Date())
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
    let path = paths[0]
    
    let filePath = path + "/Exception\(dateStr)-\(index).txt"
    
    return filePath
}

func readData(_ path: String) -> String?{
    
    var result:String?
    do{
        
        result = try String(contentsOfFile: path)
        
    }catch let error{
        print("读取本地数据Error: \(error)\n")
    }
    
    return result
}

func writeData(data:String){
    
    if curPath == nil {
        
        var i = 0
        
        while FileManager.default.fileExists(atPath: dataPath(i)) {
            i += 1
        }
        
        do {
            try String().write(toFile: dataPath(i), atomically: true, encoding: String.Encoding.utf8)
            
        }catch let error{
            print("\n初始化写入文件错误:\(error)\n")
        }
        
        curPath = dataPath(i)
    }
    
    guard let fileHandle = FileHandle(forWritingAtPath: curPath!) else{
        print("\n未获取到文件句柄")
        return
    }
    
    let result = data + "\n"
    
    fileHandle.seekToEndOfFile()
    
    fileHandle.write(result.data(using: String.Encoding.utf8)!)
    fileHandle.closeFile()
}

func closeFile(){
    curPath = nil
}

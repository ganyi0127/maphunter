//
//  CoordinateTransform.swift
//  MapHunter
//
//  Created by ganyi on 2016/10/14.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
import CoreLocation

private let earthRadius: Double = 6378245
private let ee: Double = 0.00669342162296594323
class CoordinateTransform {
    
    //WGS-84 国际标准坐标体系 GCJ-02 国内坐标体系
    class func transformGCJ(fromWGBCoordinate wgsCoordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D{
       
        if isLocationInChina(location: wgsCoordinate){

            var latitude = transformLatitude(withLongitude: wgsCoordinate.longitude - 105, withLatitude: wgsCoordinate.latitude - 35)
            var longitude = transformLongitude(withLongitude: wgsCoordinate.longitude - 105, withLatitude: wgsCoordinate.latitude - 35)
            
            let radLatitude = wgsCoordinate.latitude * M_PI / 180
            let degree  = 1 - pow(sin(radLatitude), 2) * ee
            let sqrtDegree = sqrt(degree)
            
            latitude = (latitude * 180) / ((earthRadius * (1 - ee)) / (degree * sqrtDegree) * M_PI)
            longitude = (longitude * 180) / (earthRadius * M_PI * cos(radLatitude) / sqrtDegree)
            
            return CLLocationCoordinate2D(latitude: wgsCoordinate.latitude + latitude, longitude: wgsCoordinate.longitude + longitude)
        }

        return wgsCoordinate
    }
    
    class func isLocationInChina(location: CLLocationCoordinate2D) -> Bool{
        if location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271{
            return false
        }
        return true
    }
    
    private class func transformLatitude(withLongitude longitude: Double, withLatitude latitude: Double) -> Double{
        var resultLatitude = -100 + longitude * 2 + latitude * 3 + pow(latitude, 2) * 0.2 + longitude * latitude * 0.1 + sqrt(abs(longitude)) * 0.2
        resultLatitude += (sin(longitude * M_PI * 6) + sin(longitude * M_PI * 2)) * 40 / 3
        resultLatitude += (sin(latitude * M_PI) + sin(latitude * M_PI / 3) * 2) * 40 / 3
        let plus = sin(latitude * M_PI / 12) * 160 + sin(latitude * M_PI / 30) * 320
        resultLatitude += plus * 2 / 3
        return resultLatitude
    }
    
    private class func transformLongitude(withLongitude longitude: Double, withLatitude latitude: Double) -> Double{
        var resultLongitude = 300 + longitude + latitude * 2 + pow(latitude, 2) * 0.1 + longitude * latitude * 0.1 + sqrt(abs(longitude)) * 0.1
        resultLongitude += (sin(longitude * M_PI * 6) + sin(longitude * M_PI * 2)) * 40 / 3
        resultLongitude += (sin(longitude * M_PI) + sin(longitude * M_PI / 3) * 2) * 40 / 3
        resultLongitude += (sin(longitude * M_PI / 12) + sin(longitude * M_PI / 30) * 2) * 300 / 3
        return resultLongitude
    }
}

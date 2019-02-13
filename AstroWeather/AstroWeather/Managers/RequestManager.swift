//
//  RequestManager.swift
//  AstroWeather
//
//  Created by Gonzalo Barrios on 2/9/19.
//  Copyright © 2019 Gonzalo Barrios. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class RequestManager {
    
    static let sharedInstance = RequestManager()
    
    typealias response = (Weather?,Error?) -> Void
    
    func getWeather(cityName: String?, coordinate: CLLocation?, completion: @escaping response) {
        var params: [String: String] = ["units":"metric", "appid": RequestHelper.sharedInstance.accessToken]
        
        if let cityName = cityName {
            params["q"] = cityName
        } else if let coordinate = coordinate as CLLocation? {
            let lat = String(coordinate.coordinate.latitude)
            let lon = String(coordinate.coordinate.longitude)
            params["lat"] = lat
            params["lon"] = lon
        } else {
            completion(nil, nil)
        }
        
        RequestHelper.sharedInstance.performRequest(endpoint: RequestHelper.Endpoint.weather, method: .get, parameters: params, encoding: URLEncoding.default , headers: nil, completion: { (json, error) in
            if let error = error {
                completion(nil, error)
            } else if let json = json {
                var weather = Weather(json: json)
                if weather == nil {
                    completion(nil, nil)
                } else {
                    weather!.imageURL = RequestHelper.sharedInstance.imageURL + (weather?.iconId)! + ".png"
                    completion(weather, nil)
                }
            }
        })
        
    }
}

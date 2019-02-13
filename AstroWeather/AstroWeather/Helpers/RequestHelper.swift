//
//  RequestHelper.swift
//  AstroWeather
//
//  Created by Gonzalo Barrios on 2/11/19.
//  Copyright © 2019 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RequestHelper {
    
    static let sharedInstance = RequestHelper()
    
    let baseUrl: String = "https://api.openweathermap.org/data/2.5/"
    let accessToken = "1111111111111111111"
    let imageURL = "https://openweathermap.org/img/w/"
    
    enum Endpoint: String {
        case weather = "/weather?"
    }
    
    typealias response = (JSON?,Error?) -> Void
    
    func performRequest(endpoint: Endpoint, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping response) {
        let url = baseUrl + endpoint.rawValue
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                completion(JSON(value), nil)
            }
        }
    }
    
}

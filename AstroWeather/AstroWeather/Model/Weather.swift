//
//  Weather.swift
//  AstroWeather
//
//  Created by Gonzalo Barrios on 2/11/19.
//  Copyright © 2019 Gonzalo Barrios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Weather {
    
    var description: String
    var temp: String
    var minTemp: String
    var maxTemp: String
    var wind: String
    var pressure: String
    var humidity: String
    var city: String
    var iconId: String
    var imageURL: String? = nil
    
    init?(json: JSON) {
        
        var weatherJSONs: [JSON] = json["weather"].arrayValue
        guard !weatherJSONs.isEmpty else {
            return nil
        }

        // Weather JSON
        let weatherJSON = weatherJSONs[0]
        let iconId = weatherJSON["icon"].stringValue
        let description = weatherJSON["description"].stringValue

        // Main JSON
        let mainJSON = json["main"]
        let tempValue = mainJSON["temp"].intValue
        let minTemp = mainJSON["temp_min"].intValue
        let maxTemp = mainJSON["temp_max"].intValue
        let pressure = mainJSON["pressure"].stringValue
        let humidityValue = mainJSON["humidity"].stringValue
        
        // Wind JSON
        let windJSON =  json["wind"]
        let windSpeedValue = windJSON["speed"].doubleValue
        let windSpeedRounded = Double(round(100*windSpeedValue)/100)
        let city = json["name"].stringValue
        
        self.description = description.capitalized
        self.temp = "" + String(tempValue) + "°"
        self.minTemp = String(minTemp) + "°"
        self.maxTemp = String(maxTemp) + "°"
        self.wind = String(windSpeedRounded) + " Km/h"
        self.humidity = humidityValue + " %"
        self.pressure = pressure + " hPa"
        self.city = city
        self.iconId = iconId
        
    }
    
}

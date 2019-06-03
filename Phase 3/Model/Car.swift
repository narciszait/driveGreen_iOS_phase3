//
//  Car.swift
//  Phase 1
//
//  Created by Narcis Zait on 04/02/2019.
//  Copyright © 2019 Narcis Zait. All rights reserved.
//

import Foundation

typealias Car = [CarElement]


class CarElement: Codable { //NSObject, Codable, NSCoding
    let latitude, longitude, batteryPercentage, interestInTheCar: String
    let field5: Field5

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case batteryPercentage = "Battery percentage"
        case interestInTheCar = "Interest in the car"
        case field5
    }

    init(latitude: String, longitude: String, batteryPercentage: String, interestInTheCar: String, field5: Field5) {
        self.latitude = latitude
        self.longitude = longitude
        self.batteryPercentage = batteryPercentage
        self.interestInTheCar = interestInTheCar
        self.field5 = field5
    }

    class func parseFromLocal() -> Car {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "carsJSON", ofType: "json")!))
            
            return try JSONDecoder().decode(Car.self, from: data)
            
        } catch {
            print(error)
            return Car()
        }
    }
}

enum Field5: String, Codable {
    case field5Good = "Good"
    case good = "good"
}

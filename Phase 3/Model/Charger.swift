//
//  Charger.swift
//  Phase 1
//
//  Created by Narcis Zait on 12/03/2019.
//  Copyright © 2019 Narcis Zait. All rights reserved.
//

import Foundation

typealias Charger = [ChargerElement]

class ChargerElement: Codable {
    let latitude, longitude: Double
    let interest, history: Int
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case interest = "Interest"
        case history = "History"
    }
    
    init(latitude: Double, longitude: Double, interest: Int, history: Int) throws {
        self.latitude = latitude
        self.longitude = longitude
        self.interest = interest
        self.history = history
    }
    
    class func parseFromLocal() -> Charger {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "chargersJSON", ofType: "json")!))
            
            return try JSONDecoder().decode(Charger.self, from: data)
            
        } catch {
            print(error)
            return Charger()
        }
    }
}

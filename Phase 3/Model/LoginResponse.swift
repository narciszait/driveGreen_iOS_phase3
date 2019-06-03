//
//  LoginResponse.swift
//  Phase 1
//
//  Created by Narcis Zait on 03/06/2019.
//  Copyright © 2019 Narcis Zait. All rights reserved.
//

import Foundation

struct LoginResponseData: Codable {
    var id: Int?
    var token: String
    var userID: Int
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

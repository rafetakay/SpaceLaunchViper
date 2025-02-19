//
//  Patch.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//

import Foundation

struct Patch: Codable {
    let small: String?
    let large: String?
    
    enum CodingKeys: String, CodingKey {
        case small = "small"
        case large = "large"
    }
}

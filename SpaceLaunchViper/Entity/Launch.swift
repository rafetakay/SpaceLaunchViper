//
//  Launch.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//

import Foundation

struct Launch: Codable {
    
    let id: String
    let name: String
    let date: String
    let links: Links
    let details : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case date = "date_utc"
        case links = "links"
        case details = "details"
    }
    
}

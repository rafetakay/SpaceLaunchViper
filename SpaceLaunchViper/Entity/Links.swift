//
//  Links.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//

import Foundation

struct Links: Codable {
    let patch: Patch?
    let youtubeid: String?
    let presskitlink: String?
    
    enum CodingKeys: String, CodingKey {
        case patch = "patch"
        case youtubeid = "youtube_id"
        case presskitlink = "presskit"
    }
}

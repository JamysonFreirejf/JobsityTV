//
//  ImageFullContent.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import Foundation

struct ImageFullContent: Codable {
    let type: String
    let resolutions: ResolutionContent?
    
    var isBackground: Bool {
        type == "background"
    }
}

struct ResolutionContent: Codable {
    let original: ImageURLContent?
}

struct ImageURLContent: Codable {
    let url: String
}

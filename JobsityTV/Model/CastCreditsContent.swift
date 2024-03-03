//
//  CastCreditsContent.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import Foundation

struct CastCreditsContent: Codable {
    let embeded: SearchShow?
    
    private enum CodingKeys: String, CodingKey {
        case embeded = "_embedded"
    }
}

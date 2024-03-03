//
//  Util+String.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import Foundation

extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

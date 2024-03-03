//
//  SearchChoiceTableViewCell.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import UIKit

final class SearchChoiceTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setUpView(title: String?) {
        titleLabel.text = title
    }
}

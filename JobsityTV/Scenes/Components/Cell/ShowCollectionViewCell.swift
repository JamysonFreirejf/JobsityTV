//
//  ShowCollectionViewCell.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import PINRemoteImage

struct ShowSearchData {
    let id: Int?
    let title: String?
    let image: String?
}

final class ShowCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var showImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private lazy var placeholder: UIImage? = {
        UIImage(systemName: "photo.artframe")
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showImageView.tintColor = .label
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showImageView.image = nil
    }
    
    func setUpView(content: ShowSearchData?) {
        titleLabel.text = content?.title
        
        guard let imageURL = content?.image,
              let url = URL(string: imageURL) else {
            showImageView.image = placeholder
            return
        }
        showImageView.pin_setImage(from: url,
                                   placeholderImage: placeholder)
    }
}


//
//  BannerCollectionViewCell.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 02/03/24.
//

import UIKit
import PINRemoteImage

final class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var bannerImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerImageView.image = nil
    }

    func setUpView(content: ImageFullContent?) {
        guard let imageURL = content?.resolutions?.original?.url,
              let url = URL(string: imageURL) else {
            return
        }
        bannerImageView.pin_setImage(from: url)
    }
}

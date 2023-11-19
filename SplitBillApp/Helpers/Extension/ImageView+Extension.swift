//
//  ImageView+Extension.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import UIKit.UIImageView
import Kingfisher

extension UIImageView {
    func setPicture(url: String) {
        guard let imageURL = URL(string: url) else { return}
        self.kf.setImage(with: imageURL)
    }
}


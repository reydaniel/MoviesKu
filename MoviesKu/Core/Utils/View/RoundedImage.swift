//
//  RoundedImage.swift
//  MoviesKu
//
//  Created by ReyDaniel on 06/12/21.
//

import UIKit

extension UIImageView {
    func setCornerRadius(image: UIImageView, radius: Int) {
        image.layer.cornerRadius = CGFloat(radius)
        image.clipsToBounds = true
    }
    
    func circleImage(image: UIImageView) {
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
    }
}

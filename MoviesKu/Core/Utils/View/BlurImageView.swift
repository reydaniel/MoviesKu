//
//  BlurImageView.swift
//  MoviesKu
//
//  Created by ReyDaniel on 01/12/21.
//

import Foundation
import UIKit

struct BlurImageView {
    func makeBlur(for imageView: UIImageView) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
    }
}

//
//  ProfileViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 06/12/21.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfile()
    }
    
    func setUpProfile() {
        profileImage.image = UIImage(named: "Rey")
        profileImage.circleImage(image: profileImage)
        profileName.text = "Reynaldi Daniel"
        profileDesc.text = "Seorang peternak dan mudah-mudahan bisa jadi iOS Dev di tahun 2022"
    }
}

//
//  NowPlayingTableViewCell.swift
//  MoviesKu
//
//  Created by ReyDaniel on 28/11/21.
//

import UIKit

class PopularViewCell: UITableViewCell {
    
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

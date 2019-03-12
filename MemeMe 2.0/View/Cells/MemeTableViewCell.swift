//
//  MemeTableViewCell.swift
//  MemeMe 2.0
//
//  Created by Justin Kampen on 1/1/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: MemeTableViewCell: UITableViewCell

class MemeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTopLabel: UILabel!
    @IBOutlet weak var memeBottomLabel: UILabel!

    // MARK: - Setup Table View Cell
    
    func fillCell(_ meme: Meme) {
        memeImageView.image = meme.originalImage
        memeTopLabel.text = meme.topText
        memeBottomLabel.text = meme.bottomText
    }
}

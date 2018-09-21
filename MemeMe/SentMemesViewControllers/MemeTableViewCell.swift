//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Giray Gençaslan on 4.09.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    // MARK: - Meme table view cell objects
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!
    
    // MARK: - Fill cell
    
    func fillCell(meme: Meme) {
        originalImageView.image = meme.memedImage
        memeTextLabel.text = "\(meme.topText) ... \(meme.bottomText)"
    }
}

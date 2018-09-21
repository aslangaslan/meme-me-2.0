//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Giray Gençaslan on 4.09.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Meme collection view item objects
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    // MARK: - Fill cell
    
    func fillCell(meme: Meme) {
        memedImageView.image = meme.memedImage
    }
    
}

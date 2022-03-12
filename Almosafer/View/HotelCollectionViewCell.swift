//
//  HotelCollectionViewCell.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 11/03/2022.
//

import UIKit

class HotelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var reviewScore: UILabel!
    @IBOutlet weak var reviewScoreDescription: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var reviewStack: UIView!
    
}

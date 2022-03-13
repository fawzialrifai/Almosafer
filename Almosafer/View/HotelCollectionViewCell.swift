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
    @IBOutlet weak var reviewScore: LabelWithPadding!
    @IBOutlet weak var reviewScoreDescription: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var reviewStack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.secondarySystemGroupedBackground
        layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        setUpShadow(for: self)
        customizeScoreLabel()
        layoutIfNeeded()
    }
    
    func customizeScoreLabel() {
        reviewScore.padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        reviewScore.layer.cornerRadius = 4
        reviewScore.layer.masksToBounds = true
    }
    
}

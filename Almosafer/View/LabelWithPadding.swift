//
//  LabelWithPadding.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 13/03/2022.
//

import UIKit

class LabelWithPadding: UILabel {
    
    var padding: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + padding.left + padding.right, height: super.intrinsicContentSize.height + padding.top + padding.bottom)
    }
    
}

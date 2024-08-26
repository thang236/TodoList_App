//
//  DateCollectionViewCell.swift
//  TodoList_App
//
//  Created by Louis Macbook on 22/08/2024.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var dateOfWeekLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        assert(dateOfWeekLabel != nil, "dateOfWeekLabel outlet is not connected.")
        assert(dateLabel != nil, "dateLabel outlet is not connected.")
    }

    func setupCollection(date: String) {
        let dateComponents = date.components(separatedBy: "-")
        if dateComponents.count == 4 {
            dateLabel.text = dateComponents[0]
            dateOfWeekLabel.text = dateComponents[3]
        }
    }

    func selectedItem(maxAlpha: CGFloat) {
        dateLabel.textColor = UIColor.white.withAlphaComponent(maxAlpha)
        dateOfWeekLabel.textColor = UIColor.white.withAlphaComponent(maxAlpha)
//        dateLabel.textColor = .white
//        dateOfWeekLabel.textColor = .white
    }

    func itemIsNotSelected(minAlpha: CGFloat) {
        dateLabel.textColor = UIColor.white.withAlphaComponent(minAlpha)
        dateOfWeekLabel.textColor = UIColor.white.withAlphaComponent(minAlpha)
    }
}

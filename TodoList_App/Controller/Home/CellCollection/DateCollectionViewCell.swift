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
    }

    func setupCollection(date: String) {
        let dateComponents = date.dateComponentsSeparated()
        if let day = dateComponents.day, let weekDate = dateComponents.weekDay {
            dateLabel.text = day
            dateOfWeekLabel.text = weekDate
        }
    }

    func selectedItem(maxAlpha: CGFloat) {
        dateLabel.textColor = UIColor.white.withAlphaComponent(maxAlpha)
        dateOfWeekLabel.textColor = UIColor.white.withAlphaComponent(maxAlpha)
    }

    func itemIsNotSelected(minAlpha: CGFloat) {
        dateLabel.textColor = UIColor.white.withAlphaComponent(minAlpha)
        dateOfWeekLabel.textColor = UIColor.white.withAlphaComponent(minAlpha)
    }
}

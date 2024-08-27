//
//  TaskTableViewCell.swift
//  TodoList_App
//
//  Created by Louis Macbook on 23/08/2024.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet var importantImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        layer.cornerRadius = 16
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupTableView(task: TaskModel) {
        selectionStyle = .none
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        timeLabel.text = "\(task.time)"
        dateLabel.text = task.date
        if task.important {
            importantImage.isHidden = false
        } else {
            importantImage.isHidden = true
        }
    }
}

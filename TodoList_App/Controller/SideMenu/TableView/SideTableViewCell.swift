//
//  SideTableViewCell.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import UIKit

class SideTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        iconImageView.tintColor = .white
        titleLabel.textColor = .white
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.2)
        selectedBackgroundView = myCustomSelectionColorView
    }

    func setupTableViewCell(sideMenu: SideMenuModel) {
        iconImageView.image = sideMenu.icon
        titleLabel.text = sideMenu.title
        if sideMenu.title == "Switch Theme" {
            let themeSwitch = UISwitch()
            themeSwitch.isOn = traitCollection.userInterfaceStyle == .dark
            themeSwitch.addTarget(self, action: #selector(switchThemeToggled(_:)), for: .valueChanged)
            accessoryView = themeSwitch
        } else {
            accessoryView = nil
        }
    }

    @objc func switchThemeToggled(_: UISwitch) {}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

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
        if sideMenu.title == "Is dark mode" {
            let themeSwitch = UISwitch()
            themeSwitch.backgroundColor = .white
            themeSwitch.layer.cornerRadius = themeSwitch.frame.height / 2
            themeSwitch.isOn = UserDefaults.standard.bool(forKey: .isDarkMode)
            themeSwitch.addTarget(self, action: #selector(switchThemeToggled(_:)), for: .valueChanged)
            accessoryView = themeSwitch
        } else {
            accessoryView = nil
        }
    }

    @objc func switchThemeToggled(_ sender: UISwitch) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        if sender.isOn {
            window.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: .isDarkMode)
        } else {
            window.overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(false, forKey: .isDarkMode)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

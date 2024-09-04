//
//  SettingViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
    
        // Do any additional setup after loading the view.
    }

    private func setupNavigation() {
        navigationItem.hidesBackButton = true
        let magnifyingGlassButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        magnifyingGlassButton.tintColor = .white

        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(searchButtonTapped))
        calendarButton.tintColor = .white

        navigationItem.rightBarButtonItems = [
            magnifyingGlassButton, calendarButton,
        ]
        let leftButton = UIBarButtonItem(image: UIImage(named: "dashboard"), style: .plain, target: self, action: #selector(searchButtonTapped))
        leftButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
        let image = UIImage(named: "checked")
        let imageView = UIImageView(image: image)
        let titleLabel = UILabel()
        titleLabel.text = "To-do"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#B3B3AC")
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        navigationItem.titleView = stackView

        leftButton.target = revealViewController()
        leftButton.action = #selector(revealViewController()?.revealSideMenu)
        
    }
    
    @objc func searchButtonTapped() {
        
    }
    

}

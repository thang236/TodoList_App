//
//  SideMenuViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
    func closeSideMenu()
    func selectedEditProfile()
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var headerTitleLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var sideMenuTableView: UITableView!
    var account: AccountModel
    init(account: AccountModel) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    var delegate: SideMenuViewControllerDelegate?
    private var defaultHighlightedCell: Int = 0
    private var menu = [SideMenuModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        print(account)

        // TableView
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.backgroundColor = .clear

        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

        sideMenuTableView.registerCell(cellType: SideTableViewCell.self)
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.closeSideMenu()
    }
    
    @IBAction func didTapEditProfileButton(_ sender: Any) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.selectedEditProfile()
    }
    
    
    func setupMenu() {
        headerTitleLabel.text = "Hello \(account.name)"
        emailLabel.text = account.username
        guard let house = UIImage(systemName: "house"),
              let gear = UIImage(systemName: "gear"),
              let moon = UIImage(systemName: "moon")
        else {
            return
        }
        menu = [
            SideMenuModel(icon: house, title: "Home"),
            SideMenuModel(icon: gear, title: "Settings"),
            SideMenuModel(icon: moon, title: "Switch Theme"),
        ]
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.configure(cellType: SideTableViewCell.self, at: indexPath, with: menu[indexPath.row]) { cell in
            cell.setupTableViewCell(sideMenu: menu[indexPath.row])
        }
        
       
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        delegate?.selectedCell(indexPath.row)
        
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 44
    }
}

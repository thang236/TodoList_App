//
//  HomeViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 16/08/2024.
//

import Alamofire
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var dateCollectionView: UICollectionView!
    @IBOutlet var importanceButton: UIButton!

    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var allButton: UIButton!
    private var centerItem = -1
    private let authService: AuthService
    private var arrayDates = [String]()
    private var isImportance: Bool = false
    private var tasks = [TaskModel]()
    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    static func create() -> HomeViewController {
        let authService = AuthServiceImpl()
        let homeVC = HomeViewController(authService: authService)
        return homeVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        generateDatesForCurrentYear()
        setupTableView()
    }

    private func getTaskFromAPI() {
        let components = arrayDates[centerItem].components(separatedBy: "-")
        let date = "\(components[0])-\(components[1])-\(components[2])"
        print(date)
        let importance = isImportance ? "true" : ""
        authService.fetchTask(isImportance: importance, dateSearch: date) { result in
            switch result {
            case let .success(data):
                self.tasks = data
                self.taskTableView.reloadData()
                print(self.tasks.count)
            case let .failure(error):
                self.showAlert(with: "Error", message: "Failed to fetch tasks: \(error.localizedDescription)")
                print("error to fetch task : \(error)")
            }
        }
    }

    func setupTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        taskTableView.register(nib, forCellReuseIdentifier: "TaskTableViewCell")
    }

    func generateDatesForCurrentYear() {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let currentDay = calendar.component(.day, from: Date())
        centerItem = currentDay - 1

        var dateComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
        let range = calendar.range(of: .day, in: .month, for: calendar.date(from: dateComponents)!)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy-EEE"

        for day in range {
            dateComponents.day = day
            if let date = calendar.date(from: dateComponents) {
                arrayDates.append(dateFormatter.string(from: date))
            }
        }

        setupCollectionView()
    }

    func setupCollectionView() {
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.registerCell(cellType: DateCollectionViewCell.self, nibName: "DateCollectionViewCell")
        let inset = (dateCollectionView.frame.width - (dateCollectionView.frame.width - 70) / 7) / 2
        dateCollectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerCurrentItem()
    }

    func setupNavigation() {
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
    }

    @IBAction func didTapImportanceButton(_: Any) {
        isImportance = true
        toggleUnderLine(for: importanceButton, otherButton: allButton)
    }

    @IBAction func didTapAllButton(_: Any) {
        isImportance = false
        toggleUnderLine(for: allButton, otherButton: importanceButton)
    }

    func toggleUnderLine(for button: UIButton, otherButton: UIButton) {
        getTaskFromAPI()
        updateButtonTitle(button: button, isUnderlined: true)
        updateButtonTitle(button: otherButton, isUnderlined: false)
    }

    private func deleteTask(id: String) {
        authService.deleteTask(id: id) { result in
            switch result {
            case .success:
                self.tasks.removeAll { $0.id == id }
                self.taskTableView.reloadData()

            case let .failure(error):
                print("delete error ay \(error)")
            }
        }
    }

    func updateButtonTitle(button: UIButton, isUnderlined: Bool) {
        guard let title = button.titleLabel?.text else {
            return
        }
        let attributes: [NSAttributedString.Key: Any] = isUnderlined
            ? [.underlineStyle: NSUnderlineStyle.single.rawValue]
            : [:]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
    }

    @objc func searchButtonTapped() {
        print(generateDatesForCurrentYear())
    }

    func centerCurrentItem() {
        let centerIndex = IndexPath(item: centerItem, section: 0)
        dateCollectionView.scrollToItem(at: centerIndex, at: .centeredHorizontally, animated: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateCellColors(centerIndexPath: centerIndex)
        }
    }

    private func showAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return arrayDates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DateCollectionViewCell = collectionView.dequeueReusableCell(withType: DateCollectionViewCell.self, for: indexPath)
        cell.setupCollection(date: arrayDates[indexPath.row])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at \(indexPath)")
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 70) / 7
        let height = (collectionView.frame.size.height)
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.bounds.size.width / 2
        let contentOffsetX = scrollView.contentOffset.x
        let centerPoint = CGPoint(x: centerX + contentOffsetX, y: scrollView.bounds.size.height / 2)

        if let indexPath = dateCollectionView.indexPathForItem(at: centerPoint) {
            updateCellColors(centerIndexPath: indexPath)
        }
    }

    private func updateCellColors(centerIndexPath: IndexPath) {
        for indexPath in dateCollectionView.indexPathsForVisibleItems {
            if let cell = dateCollectionView.cellForItem(at: indexPath) as? DateCollectionViewCell {
                let positionDifference = abs(indexPath.row - centerIndexPath.row)
                let maxAlpha: CGFloat = 1.0
                let minAlpha: CGFloat = 0.0 // Mức giảm mạnh hơn
                let alpha = max(maxAlpha - CGFloat(positionDifference) * 0.3, minAlpha)

                if indexPath == centerIndexPath {
                    cell.selectedItem(maxAlpha: maxAlpha)
                    centerItem = indexPath.row
                    getTaskFromAPI()
                } else {
                    cell.itemIsNotSelected(minAlpha: alpha)
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return tasks.count
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }

        cell.setupTableView(task: tasks[indexPath.section])
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 5
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { _, _, completionHandler in
            print("delete \(self.tasks[indexPath.row].id)")
            self.deleteTask(id: self.tasks[indexPath.row].id)
            completionHandler(true)
        }
        let deleteImage = UIImage(systemName: "trash.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let redCircle = createCircleWithIcon(icon: deleteImage, circleColor: .red, diameter: 30)
        deleteAction.image = redCircle
//        deleteAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        deleteAction.backgroundColor = .white
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func createCircleWithIcon(icon: UIImage?, circleColor: UIColor, diameter: CGFloat) -> UIImage? {
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext(), let icon = icon else { return nil }

        context.setFillColor(circleColor.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))

        let iconRect = CGRect(
            x: (diameter - icon.size.width) / 2,
            y: (diameter - icon.size.height) / 2,
            width: icon.size.width,
            height: icon.size.height
        )

        icon.draw(in: iconRect)

        let circleWithIcon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return circleWithIcon
    }
}

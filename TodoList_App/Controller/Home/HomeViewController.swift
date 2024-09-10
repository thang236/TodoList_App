//
//  HomeViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 16/08/2024.
//

import Alamofire
import UIKit

class HomeViewController: UIViewController, AddTaskViewControllerDelegate, TaskTableViewCellDelegate, UpdateTaskViewControllerDelegate {
    @IBOutlet private var dateCollectionView: UICollectionView!
    @IBOutlet private var importanceButton: UIButton!
    @IBOutlet private var taskTableView: UITableView!
    @IBOutlet private var allButton: UIButton!
    
    private let datePicker = UIDatePicker()
    private var centerItem = -1
    private let taskService: TaskService
    private var arrayDates = [String]()
    private var isImportant: Bool = false
    private var tasks = [TaskModel]()
    private var allTask = [TaskModel]()
    private var currentDate = Date()
    var searchBar: UISearchBar!
    
    
    init(taskService: TaskService) {
        self.taskService = taskService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    
    static func create() -> HomeViewController {
        let taskService = TaskServiceImpl()
        let homeVC = HomeViewController(taskService: taskService)
        return homeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        generateDatesForCurrentMonth()
        setupCollectionView()
        setupTableView()
        showDatePicker()
        
    }
    
    func didCreateTask() {
        getTaskFromAPI()
    }
    
    func didUpdateTask() {
        getTaskFromAPI()
    }
    
    private func showDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width - 50, height: view.frame.height / 2.8)
        datePicker.center = view.center
        datePicker.backgroundColor = .systemGroupedBackground
        datePicker.layer.cornerRadius = 10
        datePicker.clipsToBounds = true
        datePicker.isHidden = true
        view.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        print(formatter.string(from: sender.date))
        currentDate = sender.date
        generateDatesForCurrentMonth()
        dateCollectionView.reloadData()
        centerCurrentItem()
        datePicker.isHidden = true
    }
    
    func didEditTask(cell: TaskTableViewCell) {
        if let indexPath = taskTableView.indexPath(for: cell) {
            print("Button in row \(tasks[indexPath.section]) was tapped")
            let updateTaskVC = UpdateTaskViewController.create(taskEdit: tasks[indexPath.section])
            updateTaskVC.modalPresentationStyle = .custom
            updateTaskVC.transitioningDelegate = self
            updateTaskVC.delegate = self
            present(updateTaskVC, animated: true, completion: nil)
        }
    }
    
    private func getTaskFromAPI() {
        let dateString = arrayDates[centerItem]
        guard let date = dateString.formattedDate() else {
            return
        }
        let important = isImportant ? "true" : ""
        taskService.fetchTask(isImportant: important, dateSearch: date) { result in
            switch result {
            case let .success(data):
                self.tasks = data
                if self.isImportant {
                    var filterImportance = [TaskModel]()
                    for task in self.tasks {
                        if task.important == true {
                            filterImportance.append(task)
                        }
                        self.tasks = filterImportance
                    }
                }
                self.taskTableView.reloadData()
            case let .failure(error):
                self.showAlert(title: "Error", message: "Failed to fetch tasks: \(error.localizedDescription)")
                print("error to fetch task : \(error)")
            }
        }
    }
    
    private func setupTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.registerCell(cellType: TaskTableViewCell.self)
    }
    
    private func generateDatesForCurrentMonth() {
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: currentDate)
        centerItem = currentDay - 1
        arrayDates = Date.generateDatesForCurrentMonth(currentMonth: calendar.component(.month, from: currentDate))
    }
    
    @IBAction private func didTapAddButton(_: Any) {
        let addTaskVC = AddTaskViewController.create()
        addTaskVC.modalPresentationStyle = .custom
        addTaskVC.transitioningDelegate = self
        addTaskVC.delegate = self
        present(addTaskVC, animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
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
    
    private func setupNavigation() {
        navigationItem.hidesBackButton = true
        let magnifyingGlassButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        magnifyingGlassButton.tintColor = .white
        
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
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
    
    @IBAction private func didTapImportanceButton(_: Any) {
        isImportant = true
        toggleUnderLine(for: importanceButton, otherButton: allButton)
    }
    
    @IBAction private func didTapAllButton(_: Any) {
        isImportant = false
        toggleUnderLine(for: allButton, otherButton: importanceButton)
    }
    
    private func toggleUnderLine(for button: UIButton, otherButton: UIButton) {
        getTaskFromAPI()
        updateButtonTitle(button: button, isUnderlined: true)
        updateButtonTitle(button: otherButton, isUnderlined: false)
    }
    
    private func deleteTask(id: String) {
        taskService.deleteTask(id: id) { result in
            switch result {
            case .success:
                self.tasks.removeAll { $0.id == id }
                self.taskTableView.reloadData()
            case let .failure(error):
                print("delete error ay \(error)")
            }
        }
    }
    
    private func updateButtonTitle(button: UIButton, isUnderlined: Bool) {
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
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.titleView = nil
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Tìm kiếm..."
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchBar
        getAllData()
        
    }
    func getAllData(){
        taskService.fetchAllTask() { result in
            switch result {
            case let .success(data):
                self.allTask = data
            case let .failure(error):
                self.showAlert(title: "Warning", message: "Search is error: \(error)")
            }
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        setupNavigation()
        getTaskFromAPI()
    }
    @objc func calendarButtonTapped(_: UIButton) {
        datePicker.isHidden = false
    }
    
    private func centerCurrentItem() {
        let centerIndex = IndexPath(item: centerItem, section: 0)
        dateCollectionView.scrollToItem(at: centerIndex, at: .centeredHorizontally, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateCellColors(centerIndexPath: centerIndex)
        }
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
                let minAlpha: CGFloat = 0.0
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
        let cell = tableView.configure(cellType: TaskTableViewCell.self, at: indexPath, with: tasks[indexPath.section]) { cell in
            cell.taskDelegate = self
            cell.setupTableView(task: tasks[indexPath.section])
        }
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
        deleteAction.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.0)
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

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tasks = allTask
        } else{
            tasks = allTask.filter { item in
                return item.title.lowercased().contains(searchText.lowercased())
            }
        }
        taskTableView.reloadData()
    }
    
}

//
//  AddTaskViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import UIKit

protocol AddTaskViewControllerDelegate {
    func didCreateTask(newTask: TaskModel)
}

class AddTaskViewController: UIViewController {
    var delegate: AddTaskViewControllerDelegate?
    @IBOutlet private var descriptionTextField: UITextView!
    @IBOutlet private var timeTextField: UITextField!
    @IBOutlet private var dateTextField: UITextField!
    @IBOutlet private var nameTaskTextField: UITextField!
    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var createButton: UIButton!
    @IBOutlet private var notImportantButton: UIButton!
    @IBOutlet private var importantButton: UIButton!
    @IBOutlet private var personButton: UIButton!
    @IBOutlet private var groupButton: UIButton!
    
    private let currentDate = Date()
    private var isImportant: Bool = false
    private var isPerson: Bool = true
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    private let taskService: TaskService
    init(taskService: TaskService) {
        self.taskService = taskService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    
    static func create() -> AddTaskViewController {
        let taskService = TaskServiceImpl()
        let addTaskVC = AddTaskViewController(taskService: taskService)
        
        return addTaskVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTexField()
        setupLayout()
        showTimePicker()
        showDatePicker()
    }
    
    override func viewDidAppear(_: Bool) {
        setColorCategory(category: isPerson)
        setImageImportant(isImportant: isImportant)
    }
    
    private func setupTexField() {
        nameTaskTextField.delegate = self
        descriptionTextField.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
    }
    
    private func showTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanger(timePicker:)), for: .valueChanged)
        timePicker.frame.size = CGSize(width: 0, height: 300)
        timePicker.preferredDatePickerStyle = .wheels
        timeTextField.inputView = timePicker
        timeTextField.text = currentDate.formatTimeToString()
    }
    
    @objc private func timeChanger(timePicker: UIDatePicker) {
        timeTextField.text = timePicker.date.formatTimeToString()
    }
    
    
    
    private func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        dateTextField.text = currentDate.formatDateToString()
    }
    
    @objc private func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = datePicker.date.formatDateToString()
    }
    
    
    
    private func setupLayout() {
        self.view.layer.cornerRadius = 20
        cancelButton.applyOutletButton(cornerRadius: 16, borderWidth: 1, borderColor: UIColor(hex: "#456ADD"))
        guard let dateImage = UIImage(named: "calender"),
              let timeImage = UIImage(named: "Time") else { return }
        dateTextField.addIconToLeft(image: dateImage, padding: 10)
        timeTextField.addIconToLeft(image: timeImage, padding: 10)
    }
    
    @IBAction private func didTapUnCheckButton(_: Any) {
        isImportant = false
        setImageImportant(isImportant: isImportant)
    }
    
    @IBAction private func didTapCheckButton(_: Any) {
        isImportant = true
        setImageImportant(isImportant: isImportant)
    }
    
    private func setImageImportant(isImportant: Bool) {
        guard let check = UIImage(named: "check_done"),
              let unCheck = UIImage(named: "check") else { return }
        if isImportant {
            importantButton.setImage(check, for: .normal)
            notImportantButton.setImage(unCheck, for: .normal)
        } else {
            importantButton.setImage(unCheck, for: .normal)
            notImportantButton.setImage(check, for: .normal)
        }
    }
    
    @IBAction private func didTapPersonButton(_: Any) {
        isPerson = true
        setColorCategory(category: isPerson)
    }
    
    @IBAction private func didTapGroupButton(_: Any) {
        isPerson = false
        setColorCategory(category: isPerson)
    }
    
    private func setColorCategory(category: Bool) {
        guard let personFill = UIImage(systemName: "person.fill"),
              let person = UIImage(systemName: "person"),
              let groupFill = UIImage(systemName: "person.3.fill"),
              let group = UIImage(systemName: "person.3") else { return }
        
        if category {
            personButton.setImage(personFill, for: .normal)
            personButton.tintColor = UIColor(hex: "#456ADD")
            groupButton.setImage(group, for: .normal)
            groupButton.tintColor = UIColor(hex: "#BFBFBF")
        } else {
            personButton.setImage(person, for: .normal)
            personButton.tintColor = UIColor(hex: "#BFBFBF")
            groupButton.setImage(groupFill, for: .normal)
            groupButton.tintColor = UIColor(hex: "#456ADD")
        }
    }
    
    @IBAction private func didTapCancelButton(_: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapCreateButton(_: Any) {
        guard let title = nameTaskTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let date = dateTextField.text, !date.isEmpty,
              let time = timeTextField.text, !time.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill all field")
            return
        }
        let newTask = TaskModel(id: "", title: title, description: description, important: isImportant, date: date, time: time, isGroup: isPerson)
        addTask(newTask: newTask)
    }
    
    private func addTask(newTask: TaskModel){
        guard let delegate = delegate else { return }
        
        taskService.addTask(task: newTask) { result in
            switch result {
            case let .success(taskResponse):
                delegate.didCreateTask(newTask: taskResponse)
                self.dismiss(animated: true)
                self.showAlert(title: "notification", message: "Add new task complete")
                
            case let .failure(error):
                print(error)
                self.showAlert(title: "Error", message: "Some thing is wrong: \(error)")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension AddTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

//
//  AddTaskViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import UIKit

protocol AddTaskViewControllerDelegate {
    func didCreateTask(_ task: TaskModel)
}

class AddTaskViewController: UIViewController {
    var delegate: AddTaskViewControllerDelegate?
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var nameTaskTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var notImportantButton: UIButton!
    @IBOutlet var importantButton: UIButton!
    @IBOutlet var personButton: UIButton!
    @IBOutlet var groupButton: UIButton!

    private var isImportant: Bool = false
    private var isPerson: Bool = true
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()

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
        view.layer.cornerRadius = 20
        showTimePicker()
    }

    override func viewDidAppear(_: Bool) {
        setColorCategory(category: isPerson)
        setImageImportant(isImportant: isImportant)
    }

    func setupTexField() {
        nameTaskTextField.delegate = self
        descriptionTextField.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        showDatePicker()
    }

    func showTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanger(timePicker:)), for: .valueChanged)
        timePicker.frame.size = CGSize(width: 0, height: 300)
        timePicker.preferredDatePickerStyle = .wheels
        timeTextField.inputView = timePicker
        timeTextField.text = formatTime(time: Date())
    }

    @objc func timeChanger(timePicker: UIDatePicker) {
        timeTextField.text = formatTime(time: timePicker.date)
    }

    func formatTime(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: time)
    }

    func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        dateTextField.text = formatDate(date: Date())
    }

    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = formatDate(date: datePicker.date)
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }

    func setupLayout() {
        cancelButton.applyOutletButton(cornerRadius: 16, borderWidth: 1, borderColor: UIColor(hex: "#456ADD"))
        guard let dateImage = UIImage(named: "calender") else { return }
        guard let timeImage = UIImage(named: "Time") else { return }
        dateTextField.addIconToLeft(image: dateImage, padding: 10)
        timeTextField.addIconToLeft(image: timeImage, padding: 10)
    }

    @IBAction func didTapUnCheckButton(_: Any) {
        isImportant = false
        setImageImportant(isImportant: isImportant)
    }

    @IBAction func didTapCheckButton(_: Any) {
        isImportant = true
        setImageImportant(isImportant: isImportant)
    }

    func setImageImportant(isImportant: Bool) {
        guard let check = UIImage(named: "check_done") else { return }
        guard let unCheck = UIImage(named: "check") else { return }
        if isImportant {
            importantButton.setImage(check, for: .normal)
            notImportantButton.setImage(unCheck, for: .normal)
        } else {
            importantButton.setImage(unCheck, for: .normal)
            notImportantButton.setImage(check, for: .normal)
        }
    }

    @IBAction func didTapPersonButton(_: Any) {
        isPerson = true
        setColorCategory(category: isPerson)
    }

    @IBAction func didTapGroupButton(_: Any) {
        isPerson = false
        setColorCategory(category: isPerson)
    }

    func setColorCategory(category: Bool) {
        guard let personFill = UIImage(systemName: "person.fill") else { return }
        guard let person = UIImage(systemName: "person") else { return }
        guard let groupFill = UIImage(systemName: "person.3.fill") else { return }
        guard let group = UIImage(systemName: "person.3") else { return }

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

    @IBAction func didTapCancelButton(_: Any) {
        dismiss(animated: true)
    }

    @IBAction func didTapCreateButton(_: Any) {
        guard let title = nameTaskTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let date = dateTextField.text, !date.isEmpty,
              let time = timeTextField.text, !time.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill all field")
            return
        }
        let newTask = TaskModel(id: "", title: title, description: description, important: isImportant, date: date, time: time, isGroup: isPerson)
        guard let delegate = delegate else { return }

        taskService.addTask(task: newTask) { result in
            switch result {
            case let .success(task):
                delegate.didCreateTask(task)
                self.dismiss(animated: true)
                self.showAlert(title: "notification", message: "Add new task complete")

            case let .failure(error):
                print(error)
                self.showAlert(title: "Error", message: "Some thing is wrong: \(error)")
            }
        }
    }

    func showAlert(title: String, message: String) {
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

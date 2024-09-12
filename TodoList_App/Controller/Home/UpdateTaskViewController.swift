//
//  UpdateTaskViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 29/08/2024.
//

import UIKit

protocol UpdateTaskViewControllerDelegate {
    func didUpdateTask()
}

class UpdateTaskViewController: UIViewController {
    var delegate: UpdateTaskViewControllerDelegate?
    @IBOutlet private var descriptionTextField: UITextView!
    @IBOutlet private var timeTextField: UITextField!
    @IBOutlet private var dateTextField: UITextField!
    @IBOutlet private var nameTaskTextField: UITextField!
    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var notImportantButton: UIButton!
    @IBOutlet private var importantButton: UIButton!
    @IBOutlet private var personButton: UIButton!
    @IBOutlet private var groupButton: UIButton!

    private let currentDate = Date()
    private var isImportant: Bool = false
    private var isGroup: Bool = false
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()

    private let taskService: TaskService
    private let dataEdit: TaskModel?
    init(taskService: TaskService, dataEdit: TaskModel?) {
        self.taskService = taskService
        self.dataEdit = dataEdit
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    static func create(taskEdit: TaskModel?) -> UpdateTaskViewController {
        let taskService = TaskServiceImpl()
        let updateTaskVC = UpdateTaskViewController(taskService: taskService, dataEdit: taskEdit)
        return updateTaskVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTexField()
        setupLayout()
        showTimePicker()
        showDatePicker()
        setupData()
    }

    func setupData() {
        guard let taskEdit = dataEdit else {
            return
        }
        nameTaskTextField.text = taskEdit.title
        descriptionTextField.text = taskEdit.description
        isGroup = taskEdit.isGroup
        isImportant = taskEdit.important
    }

    override func viewDidAppear(_: Bool) {
        setColorCategory(category: isGroup)
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
        timePicker.locale = Locale(identifier: "en_GB")
        timeTextField.text = dataEdit?.time ?? currentDate.formatTimeToString()
        if let currentTimeText = timeTextField.text,
           let currentTime = currentTimeText.toTime()
        {
            timePicker.date = currentTime
        }
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
        dateTextField.text = dataEdit?.date ?? currentDate.formatDateToString()
        if let currentDateText = dateTextField.text,
           let currentDate = currentDateText.toDate()
        {
            datePicker.date = currentDate
        }
    }

    @objc private func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = datePicker.date.formatDateToString()
    }

    private func setupLayout() {
        view.layer.cornerRadius = 20
        cancelButton.applyOutletButton(cornerRadius: 16, borderWidth: 1, borderColor: UIColor(hex: "#456ADD"))
        guard let dateImage = UIImage(named: "calender"),
              let timeImage = UIImage(named: "Time") else { return }
        dateTextField.addIconToLeft(image: dateImage, padding: 10)
        timeTextField.addIconToLeft(image: timeImage, padding: 10)
    }

    @IBAction private func didTapNotImportant(_: Any) {
        isImportant = false
        setImageImportant(isImportant: isImportant)
    }

    @IBAction private func didTapImportant(_: Any) {
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
        isGroup = false
        setColorCategory(category: isGroup)
    }

    @IBAction private func didTapGroupButton(_: Any) {
        isGroup = true
        setColorCategory(category: isGroup)
    }

    private func setColorCategory(category: Bool) {
        guard let personFill = UIImage(systemName: "person.fill"),
              let person = UIImage(systemName: "person"),
              let groupFill = UIImage(systemName: "person.3.fill"),
              let group = UIImage(systemName: "person.3") else { return }
        if category {
            personButton.setImage(person, for: .normal)
            personButton.tintColor = UIColor(hex: "#BFBFBF")
            groupButton.setImage(groupFill, for: .normal)
            groupButton.tintColor = UIColor(hex: "#456ADD")

        } else {
            personButton.setImage(personFill, for: .normal)
            personButton.tintColor = UIColor(hex: "#456ADD")
            groupButton.setImage(group, for: .normal)
            groupButton.tintColor = UIColor(hex: "#BFBFBF")
        }
    }

    @IBAction private func didTapCancelButton(_: Any) {
        dismiss(animated: true)
    }

    @IBAction private func didTapsubmitButton(_: Any) {
        guard let title = nameTaskTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let date = dateTextField.text, !date.isEmpty,
              let time = timeTextField.text, !time.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill all field")
            return
        }

        guard let idUser = UserDefaults.standard.string(forKey: "idUser") else {
            return
        }

        if let taskID = dataEdit?.id {
            let newTask = TaskModel(idAccount: idUser, id: taskID, title: title, description: description, important: isImportant, date: date, time: time, isGroup: isGroup)
            updateTask(newTask: newTask)
        } else {
            showAlert(title: "Alert", message: "Something wrong please try again")
        }
    }

    private func updateTask(newTask: TaskModel) {
        guard let delegate = delegate else { return }
        taskService.updateTask(task: newTask) { result in
            switch result {
            case .success:
                delegate.didUpdateTask()
                self.dismiss(animated: true)

            case let .failure(error):
                print(error)
                self.showAlert(title: "Error", message: "Some thing is wrong: \(error)")
            }
        }
    }

    private func addTask(newTask: TaskModel, delegate: AddTaskViewControllerDelegate) {
        taskService.addTask(task: newTask) { result in
            switch result {
            case .success:
                delegate.didCreateTask()
                self.dismiss(animated: true)

            case let .failure(error):
                print(error)
                self.showAlert(title: "Error", message: "Some thing is wrong: \(error)")
            }
        }
    }
}

extension UpdateTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

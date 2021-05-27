//
//  TasksViewController.swift
//  TaskManager
//
//  Created by Niket on 22/05/21.
//

import Foundation
import UIKit
import SnapKit

class TasksViewController: UIViewController {
    //MARK: - Variables
    private var service: CoreDataManager = CoreDataManager.shared
    private var tasks: [Task] = []
    var mainModelArray : [String : [Task]] = [:]
    //MARK: - Contols
    private var table: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.retrieveTasks(predicate: nil) {[weak self] (result) in
            switch result {
            
            case .success(let tasks):
                DispatchQueue.main.async {
                    self?.tasks = tasks
//                    self?.table.reloadData()
                    self?.filterData()
                }
            case .failure(let error):
                UIApplication.showAlert(title: "Error!", message: error.localizedDescription)
            }
        } 
    }
    
    
    
    //MARK: - Funcs
    private func setupUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        navigationItem.title = "Tasks"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "line.horizontal.3.decrease.circle") ,
//                                                            style: .plain,
//                                                            target: self,
//                                                            action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(.lightGray),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(plusButtonTapped))
        
        table.dataSource = self
        table.delegate = self
        table.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        table.showsHorizontalScrollIndicator = false
        table.alwaysBounceVertical = true
        table.estimatedRowHeight = 66
        table.separatorStyle = .singleLine
    }
    
    private func updateTasks(result: Result<[Task], Error>) {
        switch result {
        
        case .success(let tasks):
            DispatchQueue.main.async {
                self.tasks = tasks
//                self.table.reloadData()
            }
        case .failure(let error):
            UIApplication.showAlert(title: "Error!", message: error.localizedDescription)
        }
    }
    //MARK: - Objc funcs
    
    //MARK: - Objc funcs
    @objc private func plusButtonTapped() {
        navigationController?.pushViewController(DetailsViewController(type: .createTask), animated: true)
    }

    func filterData() {

        mainModelArray.removeAll()
        let calendar = Calendar.current

        for i in 0 ..< tasks.count {
            if let taskDate = tasks[i].date {
                if calendar.isDateInToday(taskDate) {
                    addToDictionary(task: tasks[i], day: "TODAY")
                } else if calendar.isDateInTomorrow(taskDate) {
                    addToDictionary(task: tasks[i], day: "TOMORROW")
                } else {
                    addToDictionary(task: tasks[i], day: "OTHER")
                }
            }
        }
        self.table.reloadData()
    }

    func addToDictionary(task : Task, day: String) {
        if ((mainModelArray[day]) == nil) {
            mainModelArray[day] = [task]
        } else {
            mainModelArray[day]?.append(task)
        }
    }
}

//MARK: - CollectionView Delegate&DataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        let keyArray = [String] (mainModelArray.keys)
        return keyArray.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keyArray = [String] (mainModelArray.keys)
        return keyArray[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyArray = [String] (mainModelArray.keys)
        let title = keyArray[section]
        return mainModelArray[title]?.count ?? 0 //tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else {
            print("cell error")
            fatalError("Can't cast to ImageCell")
        }
        let keyArray = [String] (mainModelArray.keys)
        let title = keyArray[indexPath.section]

        let taskModel = mainModelArray[title]?[indexPath.item]
        cell.configure(model: taskModel!)
//        cell.configure(model: tasks[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyArray = [String] (mainModelArray.keys)
        let title = keyArray[indexPath.section]

        guard let taskModel = mainModelArray[title]?[indexPath.item] else {
            return
        }

        let vc = DetailsViewController(type: .editTask(task: taskModel))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            fatalError()
        }
        let keyArray = [String] (mainModelArray.keys)
        let title = keyArray[indexPath.section]
        guard let taskModel = mainModelArray[title]?[indexPath.item] else {
            return
        }

        tableView.beginUpdates()
        mainModelArray[title]?.remove(at: indexPath.row)
        service.deleteTask(task: taskModel)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        tableView.endUpdates()
    }
    
}


//MARK: - Constraints
extension TasksViewController {
    private func setupConstraints() {
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension Date {
    var day: Int? {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day
    }
}

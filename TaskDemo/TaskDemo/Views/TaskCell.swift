//
//  TaskCell.swift
//  TaskManager
//
//  Created by Niket on 22/05/21.
//

import Foundation
import UIKit

protocol TaskCellViewModel {
    var title: String? { get }
    var date: Date? { get }
    var comment: String? { get }
}

class TaskCell: UITableViewCell {
    //MARK: - Variables
    public static let reuseId = "TaskCell"

    //MARK: - Controls
    private var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Сделать дз по алгосам"
        label.font = label.font.withWeight(.medium)
        return label
    }()
    
    private var commentLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Оно оч сложное, начать делать за несколько дней"
        label.textColor = .lightGray
        return label
    }()
    
    private var dateLabel: UILabel = {
       let label = UILabel()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        label.text = df.string(from: Date())
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Funcs
    public func configure(model: TaskCellViewModel) {
        titleLabel.text = model.title
        commentLabel.text = model.comment
        if let date = model.date {
            print(model.date)
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            dateLabel.text = df.string(from: date)
        } else {
            dateLabel.text = ""
        }
    }
}

//MARK: - Constraints
extension TaskCell {
    private func setupConstraints(){
        let leftOffset = 10
        let rightInset = 10
        addSubview(titleLabel)
        addSubview(commentLabel)
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(rightInset)
            make.top.equalToSuperview().offset(5)
        }
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftOffset)
            make.top.equalToSuperview().offset(5)
            make.right.equalTo(dateLabel.snp.left)
        }
        
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftOffset)
            make.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(rightInset)
        }
    }
}

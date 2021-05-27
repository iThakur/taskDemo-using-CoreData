//
//  TextFieldView.swift
//  TaskManager
//
//  Created by Niket on 22/05/21.
//

import Foundation
import UIKit
import SnapKit
protocol TextFieldViewDelegate: AnyObject {
    func textDidChange(textFieldView: TextFieldView, newText: String)
}

class TextFieldView: UIView {
    
    private var textField: UITextField
    
    weak var delegate: TextFieldViewDelegate?
    
    
    init(placeholder: String) {
        textField = UITextField.getNormalTextField(placeholder: placeholder)
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextField))
        addGestureRecognizer(recognizer)
        
        setupTextfield()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    //MARK: - funcs
    private func setupTextfield() {
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        textField.layer.cornerRadius = 10
        textField.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        textField.clipsToBounds = true
    }
    
    public func isEmpty() -> Bool{
        return textField.text?.isEmpty ?? true
    }
    
    
    
    public func getText() -> String{
        return textField.text ?? " "
    }
    
    public func setText(newText: String) {
        textField.text = newText
    }
    //MARK: - Objc funcs
    @objc func textFieldDidChange(textField: UITextField) {
        delegate?.textDidChange(textFieldView: self, newText: textField.text ?? "")
    }
    
    
    @objc public func resignTextField() {
        textField.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

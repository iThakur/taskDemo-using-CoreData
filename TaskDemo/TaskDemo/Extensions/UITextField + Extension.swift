//
//  UITextField + Extension.swift
//  TaskManager
//
//  Created by Niket on 22/05/21.
//

import Foundation
import UIKit

extension UITextField {
    static func getNormalTextField(placeholder: String) -> UITextField{
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        textField.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        textField.clipsToBounds = true
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 19, height: textField.frame.height))
        textField.leftViewMode = .always

        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 19, height: textField.frame.height))
        textField.rightViewMode = .always
        
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        return textField
    }
}

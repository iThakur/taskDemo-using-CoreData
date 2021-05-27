//
//  CustomError.swift
//  TaskManager
//
//  Created by Niket on 22/05/21.
//

import Foundation
import UIKit

enum CustomError {
    case CoreDataError
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .CoreDataError:
            return NSLocalizedString("Core data error", comment: "")
        }
    }
}


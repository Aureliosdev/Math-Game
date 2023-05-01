//
//  Levels.swift
//  Math game
//
//  Created by Aurelio Le Clarke on 27.04.2023.
//

import Foundation



 enum Levels {
    case easy
    case medium
    case hard
    
    func keys() -> String {
        switch self {
        case .easy:
            return" easyUserScore"
        case .medium:
            return "mediumUserScore"
        case .hard:
            return "hardUserScore"
        }
    }
    
}

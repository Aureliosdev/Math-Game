//
//  UserScoreModel.swift
//  Math game
//
//  Created by Aurelio Le Clarke on 27.04.2023.
//

import Foundation

struct UserScoreModel {
    
    var timer: Timer?
    var countdown = 30
    var result: Double?
    var score = 0
    var levelOfGame = [1...9, 10...99, 100...999]
    var scoreAmount = [1,3,5]
    
    
    
}

//
//  HapticFeetback.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 23.07.2023.
//

import UIKit

struct HapticFeedback {
    
    static let shared = HapticFeedback()
    
    func perform() {
        let feedback = UISelectionFeedbackGenerator()
        feedback.prepare()
        feedback.selectionChanged()
    }
}

//
//  AlphanumericInput.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-11-20.
//

import Foundation

class AlphanumericInput: ObservableObject {
    let pattern: String
    let max: Int
    
    init(limit: Int, nums: Bool){
        max = limit
        pattern = nums ? "[^A-Za-z0-9]+" : "[^A-Za-z]+"
    }

    @Published var value = "" {
        didSet {
            let filtered = value.prefix(max).replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
            
            if value != filtered {
                value = filtered
            }
        }
    }
}


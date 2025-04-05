//
//  Increase.swift
//  2048
//
//  Created by 小火锅 on 2025/4/4.
//

import Foundation

let IncreaseListSize = 5

@Observable
class IncreaseList {
    var list: [Increase] = (0..<IncreaseListSize).map { _ in Increase() }
    private var index = 0
    
    func add(value: Int) {
        guard value != 0 else { return }
        
        list[index] = Increase(value: value, animate: true)
        
        index = (index + 1) % IncreaseListSize
    }
    
}

@Observable
class Increase: Identifiable {
    let id = UUID()
    
    var value = 0
    var animate = false
    
    init(value: Int = 0, animate: Bool = false) {
        self.value = value
        self.animate = animate
    }
}

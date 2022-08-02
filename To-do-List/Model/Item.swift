//
//  Item.swift
//  To-do-List
//
//  Created by Nguyen Tran on 8/1/22.
//

import Foundation

struct Item {
    var text:String
    var isDone: Bool
    
    init(text:String, isDone:Bool) {
        self.text = text
        self.isDone = isDone
    }
}

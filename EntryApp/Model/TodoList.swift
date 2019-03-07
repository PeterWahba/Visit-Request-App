//
//  TodoList.swift
//  Checklist
//
//  Created by Brian on 6/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation

class TodoList {
  
  var todos: [ChecklistItem] = []
  
  init() {
    
    let row0Item = ChecklistItem()
    let row1Item = ChecklistItem()
    let row2Item = ChecklistItem()
    let row3Item = ChecklistItem()
    let row4Item = ChecklistItem()
    
    row0Item.requestTitle = "Take a jog"
    row1Item.requestTitle = "Watch a movie"
    row2Item.requestTitle = "Code an app"
    row3Item.requestTitle = "Walk the dog"
    row4Item.requestTitle = "Study design patterns"
    
    todos.append(row0Item)
    todos.append(row1Item)
    todos.append(row2Item)
    todos.append(row3Item)
    todos.append(row4Item)
    
  }
  
  func newTodo() -> ChecklistItem {
    let item = ChecklistItem()
    item.requestTitle = randomTitle()
    item.checked  = true
    todos.append(item)
    return item
  }
  
  private func randomTitle() -> String {
    var titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
    let randomNumber = Int.random(in: 0 ... titles.count - 1)
    return titles[randomNumber]
  }
  
}

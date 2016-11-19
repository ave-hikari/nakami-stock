//
//  TodoDataManager.swift
//  nakamistock
//
//  Created by Hikari Yanagihara on 2016/02/22.
//  Copyright © 2016年 Hikari Yanagihara. All rights reserved.
//

import UIKit

struct TODO {
    var title : String
}

class TodoDataManager {
    let STORE_KEY = "TodoDataManager.store_key"
    
    static let sharedInstance = TodoDataManager()
    
    var todoList: [TODO]
    
    var size : Int {
        return todoList.count
    }
    
    subscript(index: Int) -> TODO {
        return todoList[index]
    }
    
    fileprivate init() {
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: self.STORE_KEY) as? [String] {
            self.todoList = data.map { title in
                TODO(title: title)
            }
        } else {
            self.todoList = []
        }
    }
    
    class func validate(_ todo: TODO!) -> Bool {
        return todo.title != ""
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let data = self.todoList.map { todo in
            todo.title
        }
        defaults.set(data, forKey: self.STORE_KEY)
        defaults.synchronize()
    }
    
    func create(_ todo: TODO!) -> Bool {
        if TodoDataManager.validate(todo) {
            self.todoList.append(todo)
            self.save()
            return true
        }
        return false
    }
    
    func update(_ todo: TODO!, at index: Int) -> Bool {
        if (index >= self.todoList.count) {
            return false
        }
        
        if TodoDataManager.validate(todo) {
            self.todoList[index] = todo
            self.save()
            return true
        }
        return false
    }
    
    func remove(_ index: Int) -> Bool {
        if (index >= self.todoList.count) {
            return false
        }
        
        self.todoList.remove(at: index)
        self.save()
        
        return true
    }
}

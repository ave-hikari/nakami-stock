//
//  TodoTableViewCell.swift
//  nakamistock
//
//  Created by Hikari Yanagihara on 2016/02/22.
//  Copyright © 2016年 Hikari Yanagihara. All rights reserved.
//

import UIKit

@objc protocol TodoTableViewCellDelegate {
    @objc optional func updateTodo(_ index: Int)
    @objc optional func removeTodo(_ index: Int)
}

class TodoTableViewCell : UITableViewCell {
    weak var delegate: TodoTableViewCellDelegate?
    var haveButtonsDisplayed = false
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.createView()
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(TodoTableViewCell.showDeleteButton))
        swipeRecognizer.direction = .left
        self.contentView.addGestureRecognizer(swipeRecognizer)
        
        self.contentView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(TodoTableViewCell.hideDeleteButton)))
    }
    
    func createView() {
        let origin  = self.frame.origin
        let size    = self.frame.size
        
        self.contentView.backgroundColor = UIColor.white
        
        //let updateButton = UIButton.buttonWithType(UIButtonType.System)
        
        let updateButton:UIButton! = UIButton.init(type: UIButtonType.custom)
        updateButton.frame = CGRect(x: size.width - 100, y: origin.y, width: 50, height: size.height)
        updateButton.backgroundColor = UIColor.lightGray
        updateButton.setTitle("edit", for: UIControlState())
        updateButton.setTitleColor(UIColor.white, for: UIControlState())
        updateButton.addTarget(self, action: #selector(TodoTableViewCell.updateTodo), for: .touchUpInside)
        
        let removeButton:UIButton! = UIButton.init(type: UIButtonType.custom)
        removeButton.frame = CGRect(x: size.width - 50, y: origin.y, width: 50, height: size.height)
        removeButton.backgroundColor = UIColor.red
        removeButton.setTitle("delete", for: UIControlState())
        removeButton.setTitleColor(UIColor.white, for: UIControlState())
        removeButton.addTarget(self, action: #selector(TodoTableViewCell.removeTodo), for: .touchUpInside)
        
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.addSubview(updateButton)
        self.backgroundView?.addSubview(removeButton)
    }
    
    func updateTodo() {
        delegate?.updateTodo?(self.tag)
    }
    
    func removeTodo() {
        delegate?.removeTodo?(self.tag)
    }
    
    func showDeleteButton() {
        if !self.haveButtonsDisplayed {
            UIView.animate(withDuration: 0.1, animations: {
                let size   = self.contentView.frame.size
                let origin = self.contentView.frame.origin
                
                self.contentView.frame = CGRect(x: origin.x - 100, y:origin.y, width:size.width, height:size.height)
                
                }, completion: { completed in self.haveButtonsDisplayed = true }) 
        }
    }
    
    func hideDeleteButton() {
        if self.haveButtonsDisplayed {
            UIView.animate(withDuration: 0.1, animations: {
                let size   = self.contentView.frame.size
                let origin = self.contentView.frame.origin
                
                self.contentView.frame = CGRect(x: origin.x + 100, y:origin.y, width:size.width, height:size.height)
                
                }, completion: { completed in self.haveButtonsDisplayed = false }) 
        }
    }
}

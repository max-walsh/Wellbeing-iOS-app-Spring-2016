//
//  Queue.swift
//  WellnessApp
//
//  Created by Max Walsh on 2/14/16.
//  Copyright © 2016 anna. All rights reserved.
//

// Special queue to remember the last 7 days worth of survey completion data

import Foundation

class Node<T> {
    var val: T? = nil
    var next: Node<T>? = nil
    var prev: Node<T>? = nil
    
    init() {}
    
    init(v: T) {
        self.val = v
    }
}

class Queue<T> {
    var count: Int = 0
    var head: Node<T> = Node<T>()
    var tail: Node<T> = Node<T>()
    var curNode: Node<T> = Node<T>()
    
    init() {}
    
    func append(v: T) {
        if self.count < 6 {
            tail.next = Node<T>(v: v)
            tail = tail.next!
            self.count++
        } else {
            let temp = Node<T>(v: v)
            temp.next = head
            head = temp
            tail = tail.prev!
        }
    }
    
}
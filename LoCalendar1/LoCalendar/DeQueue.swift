//
//  ThreadQueue.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 5/5/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//  Modified queue implementation

//----------------------------------------------------------------------------------------------------
//  Based off of:
//  Queue.swift
//  NTBSwift
//  Created by Kåre Morstøl on 11/07/14.
//  Using the "Two-Lock Concurrent Queue Algorithm" from http://www.cs.rochester.edu/research/synchronization/pseudocode/queues.html#tlq, without the locks.


class DeQueue{
    class Item{
        let value: Any?
        var next: Item?
        var prev: Item?
        init(newValue: Any?){
            if newValue != nil{
                self.value = newValue!
            }else{
                self.value = nil
            }
            
            self.next = nil
            self.prev = nil
        }
    }
    
    var _front: Item
    var _back: Item
    var count = Int()
    
    internal init(){
        _back = Item(newValue: nil)
        _front = _back
    }
    
    /// Add item to the back of the queue
    internal func pushBack(value: Any){
        self.count += 1
        _back.next = Item(newValue: value)
        _back.next?.prev = _back
        _back = _back.next!
    }
    
    /// Add item to the front of the queue
    internal func pushFront(value: Any){
        self.count += 1
        _front.prev = Item(newValue: value)
        _front.prev?.next = _front
        _front = _front.prev!
    }
    
    /// Return and remove the item at the front of the queue
    internal func popFront() -> Any?{
        
        if count == 0{
            return nil
        } else if count > 0{
            self.count -= 1
        }
//        if let newHead = _front.next{
//            _front = newHead
//            return newHead.value
//        }else{
//            return nil
//        }
//
//        if _front.next != nil{
//            _front = _front.next!
//            return _front.value
//        }else{
//            return nil
//        }
        
        
        let r = _front.value
        _front = _front.next!
        return r
    }
    
    
    /// Return and remove the item at the back of the queue
    internal func popBack() -> Any?{
        
        if count == 0{
            return nil
        }else if count > 0{
            self.count -= 1
        }
        
//        if _back.value != nil{
//            let backVal = _back.value
//            _back = _back.prev!
//            return backVal
//        }else{
//            return nil
//        }
        
        let r = _back.value
        _back = _back.prev!
        return r
    }
    
    /// Returns a boolean value determining if the queue is empty
    internal func isEmpty() -> Bool{
        return _front === _back
    }

    
    
    
    
    
    
    
    
    
    
}
/**
 Code taken from
 https://medium.com/@mohit.bhalla/thread-safety-in-ios-swift-7b75df1d2ba6
 credit: Mohit Bhalla
 */


import Foundation


public class ThreadSafeArray<T> {
    private var array: [T] = []
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    public func append(newElement: T) {
        
        self.accessQueue.async(flags:.barrier) {
            self.array.append(newElement)
        }
    }
    
    public func removeAtIndex(index: Int) {
        
        self.accessQueue.async(flags:.barrier) {
            self.array.remove(at: index)
        }
    }
    
    public var count: Int {
        var count = 0
        
        self.accessQueue.sync {
            count = self.array.count
        }
        
        return count
    }
    
    public func first() -> T? {
        var element: T?
        
        self.accessQueue.sync {
            if !self.array.isEmpty {
                element = self.array[0]
            }
        }
        
        return element
    }
    
    public subscript(index: Int) -> T {
        set {
            self.accessQueue.async(flags:.barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            self.accessQueue.sync {
                element = self.array[index]
            }
            
            return element
        }
    }
    public func isEmpty() -> Bool {
        var bool = true
        self.accessQueue.sync {
            bool = array.isEmpty
        }
        return bool
    }
    
    public func readOnlyArray() -> [T] {
        var readOnlyArray = [T]()
        self.accessQueue.sync {
            array.forEach({ t in
                readOnlyArray.append(t)
            })
        }
        return readOnlyArray
    }
    
    public func removeAll() {
        self.accessQueue.sync {
            array.removeAll()
        }
    }
    
    public func setArray(array: [T]) {
        self.accessQueue.sync {
            self.array = array
        }
    }
}

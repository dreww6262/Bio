//
//  LiveData.swift
//  Bio
//
//  Created by Andrew Williamson on 12/2/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import Foundation

class LiveData<T: Equatable> {
    typealias Listener = ((T?) -> ())
    var listener: Listener?
    
    private let thread : DispatchQueue

    var value: T {
        willSet(newValue) {
            if value != newValue {
                thread.async {
                    self.listener?(newValue)
                }
            }
        }
    }
    
    init(_ value: T, thread dispatcherThread: DispatchQueue = DispatchQueue.main) {
        self.thread = dispatcherThread
        self.value = value
    }
    
    func observe(listener: Listener?) {
        self.listener = listener
    }
}

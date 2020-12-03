//
//  LiveData.swift
//  Bio
//
//  Created by Andrew Williamson on 12/2/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import Foundation

class LiveData<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func observe(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

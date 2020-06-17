//
//  UtilityTime.swift
//  Dart1
//
//  Created by Ann McDonough on 5/25/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation

func printTimeElapsedWhenRunningCode <T> (title: String, operation: @autoclosure () -> T) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) seconds")
}

func getStartTime() -> CFAbsoluteTime {
    return CFAbsoluteTimeGetCurrent()
}

func printElapsedTime(title: String, startTime: CFAbsoluteTime) {
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) seconds")
}

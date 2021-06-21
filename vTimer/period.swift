//
//  period.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/21/21.
//

import Foundation


struct Period{
    var startingTime:Date
    var endingTime:Date
    var interval:TimeInterval
    
    init(startingTime: Date, endingTime: Date){
        self.startingTime = startingTime
        self.endingTime = endingTime
        
        interval = endingTime.timeIntervalSince(startingTime)
    }
    
    
}


//
//  TimeFormatter.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/21/21.
//

import Foundation


class TimeFormatter{
    var startingTime:Date?
    var endingTime: Date?
    
    var interval: TimeInterval?
    
    func secondsToHoursMinutesSeconds (interval : TimeInterval) -> String {
        let amountOfSeconds = Int(interval)
        let (hr, min, sec) = (amountOfSeconds / 3600, (amountOfSeconds % 3600) / 60, (amountOfSeconds % 3600) % 60)
        
        var result = ""
        
        if hr == 1{
            result += "1 Hour "
        }
        
        if hr > 1{
            result += "\(hr) Hours "
        }
        
        
        
        if min == 1{
            result += "1 Minute "
        }
        
        if min > 1{
            result += "\(min) Minutes "
        }
        
        if sec == 1{
            result += "1 Second"
        }
        
        if sec > 1{
            result += "\(sec) Seconds"
        }
        
        
        return result
    }
    
    
    func dateToReadableDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    func longLongTimeAgo(date: Date) -> String{
        let interval = Int(Date().timeIntervalSince(date))
        
        if interval < 60{
            return "Moments ago"
        }else if interval < 3600{
            return "Minutes ago"
        }else if interval < 86400{
            return "Hours ago"
        }else if interval < 172800{
            return "Yesturday"
        }else{
            return "\(interval/86400) days ago"
        }
        
    }
    
}

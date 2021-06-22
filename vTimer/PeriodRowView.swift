//
//  PeriodRowView.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/21/21.
//

import SwiftUI

struct PeriodRowView: View {
    
    init(period: Periods) {
        self.period = period
    }
    
    let period: Periods
    
    
    
    
    var body: some View {
        if period.endingTime != nil && period.startingTime != nil{
            HStack{
                Spacer()
                
                Spacer()
                
                Text(TimeFormatter().secondsToHoursMinutesSeconds(interval: period.endingTime!.timeIntervalSince(period.startingTime!)))
                    .font(.title)
                
                
                Spacer()
                Spacer()
                Spacer()
                VStack{
                    
                    Text(TimeFormatter().longLongTimeAgo(date: period.endingTime!))
                        .font(.title2)
                    
                    
                    
                }
                Spacer()
            }
        }else{
            Text("* Something went wrong here :(")
        }
    }
}

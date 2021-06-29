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

            HStack{
                Spacer()
                
                Spacer()
                
                Text(TimeFormatter().secondsToHoursMinutesSecondsLite(interval: period.endingTime!.timeIntervalSince(period.startingTime!)))
                    .font(.title3)
                
                
                Spacer()
                Spacer()
                Spacer()
                VStack{
                    
                    Spacer()
                    Text(TimeFormatter().longLongTimeAgo(date: period.endingTime!))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 5.0)
                    
                }
                Spacer()
            }
        }
//    else if period.endingTime == nil && period.startingTime != nil{
//            //user's timers is running!
//        }else{
//            Text("* Something went wrong here :(")
//        }
}

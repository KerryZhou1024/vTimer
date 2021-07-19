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
            if period.title == "" || period.title == nil{
                
                Spacer().fixedSize()
                
                Text(
                    TimeFormatter().secondsToHoursMinutesSecondsLiteUltra(interval: period.endingTime!.timeIntervalSince(period.startingTime!)))
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing,5.0)
                    
                
                Spacer();Spacer();Spacer()
                
                VStack{
                    
                    Spacer()
                    Text(TimeFormatter().longLongTimeAgo(date: period.endingTime!))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 5.0)
                        .multilineTextAlignment(.trailing)
                    
                }
                Spacer().fixedSize()
                
            }else{
                Spacer().fixedSize()
                Text(period.title!)
                    .bold()
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing,5.0)
                Spacer();Spacer();Spacer();
                
                VStack{
                    Text(
                        TimeFormatter().secondsToHoursMinutesSecondsLiteUltra(interval: period.endingTime!.timeIntervalSince(period.startingTime!)))
                        .font(.caption2)
                        .padding(.trailing, 5.0)
                        .multilineTextAlignment(.trailing)
                    
                    Text(TimeFormatter().longLongTimeAgo(date: period.endingTime!))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 5.0)
                        .multilineTextAlignment(.trailing)
                    
                }
                Spacer().fixedSize()
                
                
                
            }
        }
    }
    //    else if period.endingTime == nil && period.startingTime != nil{
    //            //user's timers is running!
    //        }else{
    //            Text("* Something went wrong here :(")
    //        }
}

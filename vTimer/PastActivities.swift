//
//  PastActivities.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/21/21.
//

import SwiftUI


class periodsCollection:ObservableObject{
    @Published var periods = [Period]()
    
    init(results: FetchedResults<Periods> ){
        for (_, result) in  results.enumerated() {
            if result.startingTime != nil && result.endingTime != nil{
                let period = Period.init(startingTime: result.startingTime!, endingTime: result.endingTime!)
                
                periods.append(period)
            }
        }
    }
}

struct PastActivities: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Periods.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Periods.startingTime, ascending: false)
        ],
        animation : .default
    ) var periods: FetchedResults<Periods>
    //
    //    @ObservedObject var collection = periodsCollection.init(results: periodsFetchedResults)
    //    @State var periods = collection.$periods
    
    
    
    @State var totalTime:String = ""
    
    
    @State var bannerColor:Color = Color.green
    
    
    var body: some View {
        
        
        VStack{
            Button(action: {
                bannerColor = Color.random
            }){
                VStack{
                    ZStack{
                        Capsule()
                            .padding(.all)
                            .frame(height: 60.0)
                            .foregroundColor(bannerColor)
                            .opacity(0.3)
                        Text("\(totalTime) total in the log!")
                            .bold()
                            .onAppear{
                                if periods.count > 0{
                                    var interval:TimeInterval = 0.0
                                    for period in periods{
                                        if let start = period.startingTime, let end = period.endingTime{
                                            interval += end.timeIntervalSince(start)
                                        }
                                        
                                    }
                                    
                                    totalTime = TimeFormatter().secondsToHoursMinutesSecondsLite(interval: interval)
                                }
                            }
                    }
                }
            }
            
            List(periods, id:\.self){ period in
                if period.endingTime != nil && period.startingTime != nil{
                    PeriodRowView(period: period)
                }
            }
            
            
            
            
            
            //            List(periodsFetchedResults,id:\.self){ period in
            //                Text("A List Item")
            //                Text("A Second List Item")
            //                Text("A Third List Item")
            //            }
        }
        
        
        
        
        
        
        
    }
}

struct PastActivities_Previews: PreviewProvider {
    static var previews: some View {
        PastActivities(totalTime: "Touchy")
    }
}



extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

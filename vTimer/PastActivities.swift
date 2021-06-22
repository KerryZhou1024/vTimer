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
            NSSortDescriptor(keyPath: \Periods.startingTime, ascending: true)
        ],
        animation : .default
    ) var periodsFetchedResults: FetchedResults<Periods>
    //
    //    @ObservedObject var collection = periodsCollection.init(results: periodsFetchedResults)
    //    @State var periods = collection.$periods
    
    
    
    
    
    
    @State var bannerColor:Color = Color.green
    
    
    var body: some View {
        
        
        VStack{
            Button(action: {
                bannerColor = Color.random
            }){
                VStack{
                    ZStack{
                        Capsule()
                            .padding(.horizontal)
                            .frame(width: .infinity, height: 60, alignment: .center)
                            .foregroundColor(bannerColor)
                            .opacity(0.3)
                        Text("242 Hours 34 Minutes so far!")
                            .bold()
                    }
                }
            }
            
            List(periodsFetchedResults, id:\.self){ period in
                PeriodRowView(period: period)
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
        PastActivities()
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

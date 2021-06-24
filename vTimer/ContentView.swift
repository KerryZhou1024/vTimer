//
//  ContentView.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/19/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Periods.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Periods.startingTime, ascending: true)
        ],
        animation : .default
    ) var periods: FetchedResults<Periods>
    
    
    
    
    //
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    ////        animation: .default)
    
    //    private var items: FetchedResults<Item>
    
    
    @State var timerIsRunning = false
    @State var totalTime:String = ""
    @State var currentTimer:String = ""
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    
    
    var body: some View {
        
        return Group {
            
            
            if !timerIsRunning{
                //when the timer is not running
                VStack{
                    
                    Spacer()
                    if totalTime != ""{
                        Text("A total of:")
                            .font(.title)
                        Text(totalTime)
                            .font(.title)
                    }else{
                        Text("Let's get started!")
                            .font(.title)
                    }
                    
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        timerIsRunning = true
                        //now save
                        
                        let newPeriod = Periods(context: managedObjectContext)
                        newPeriod.startingTime = Date()
                        
                        PersistenceController.shared.save()
                        
                    }) {
                        ZStack{
                            
                            Text("Start")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.blue)
                            
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 150, height: 150, alignment: .center)
                                .shadow(color: .black, radius: 2, x: 2, y: 2)
                                .opacity(0.5)
                            
                        }
                    }
                    
                    
                    Spacer()
                    
                }
                .onAppear{
                    if periods.count > 0{
                        
                        if (periods[periods.count - 1].endingTime == nil && periods[periods.count - 1].startingTime != nil){
                            timerIsRunning = true
                        }else{
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
            }else{
                VStack{
                    
                    Spacer()
                    
                    Text(" ")
                    
                    Text(currentTimer != "" ? currentTimer : TimeFormatter().secondsToHoursMinutesSecondsLite(interval: Date().timeIntervalSince(periods[periods.count - 1].startingTime!)))
                        .font(.title)
                        .onReceive(timer, perform: { _ in
                            currentTimer = TimeFormatter().secondsToHoursMinutesSecondsLite(interval: Date().timeIntervalSince(periods[periods.count - 1].startingTime!))
                        })
                    
                    Spacer()
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            //MARK: Remeber to update total number
                            
                            timerIsRunning = false
                            
                            periods[periods.count - 1].endingTime = Date()
                            
                            PersistenceController.shared.save()
                            currentTimer = "0"
                            
                            
                        }){
                            ZStack{
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x: 2, y: 2)
                                    .opacity(0.5)
                                Text("Stop")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            }
                        }
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                }
                
                
            }
        }
        
        
        
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let contentView = ContentView(totalTime: "67 Hours 29 Minutes", currentTimer: "42:34")
        contentView.timerIsRunning = true
        
        return contentView
        
    }
}

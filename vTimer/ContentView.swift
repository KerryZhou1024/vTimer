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
    
    @State var showSpamAlert = false;
    
    
    //
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    ////        animation: .default)
    
    //    private var items: FetchedResults<Item>
    
    
    @State var timerIsRunning = false
    @State var totalTime:String = ""
    @State var currentTimer:String = ""
    @State var totalInterval:TimeInterval = 0
    
    let timerForCurrentTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    
    
    
    var body: some View {
        
        Group {
            
            if !timerIsRunning{
                VStack{
                    
                    Spacer()
                    Text(totalTime)
                        .font(.title)
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        startButtonPressed()
                        
                    }) {
                        ZStack{
                            
                            Text("Start")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .bold()
                            
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 150, height: 150, alignment: .center)
                                .shadow(color: .black, radius: 2, x: 2, y: 2)
                                .opacity(0.5)
                            
                        }
                    }
                    
                    
                    Spacer()
                    
                }
                .onChange(of: periods.count) { _ in
                    updateView()
                }
            }else{
                VStack{
                    
                    Spacer()
                    
                    Text(" ")
                    
                    Text(currentTimer != "" ? currentTimer : TimeFormatter().secondsToHoursMinutesSecondsLite(interval: Date().timeIntervalSince(periods[periods.count - 1].startingTime!)))
                        .font(.title)
                        .onReceive(timerForCurrentTimer, perform: { _ in
                            currentTimer = TimeFormatter().secondsToHoursMinutesSecondsLite(interval: Date().timeIntervalSince(periods[periods.count - 1].startingTime!))
                        })
                    
                    Spacer()
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            //MARK: Remeber to update total number
                            endButtonPressed()
                            
                            
                        }){
                            ZStack{
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x: 2, y: 2)
                                    .opacity(0.5)
                                Text("Stop")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .bold()
                            }
                        }
                        
                        
                        Spacer()
                        
                    }
                    
//                    .alert(isPresented: $showSpamAlert, content: {
//                        Alert(title: "Error", message: "Please Do Not Spam Click As You May Encounter Fatal Bug.", dismissButton: .default(Text("OK")))
//                    })
                    
                    Spacer()
                }
                .onChange(of: periods[periods.count - 1].endingTime) { _ in
                    updateView()
                }
            }
        }
        .onAppear {
            updateView()
        }
        
    }
    
    func updateView(){
        
        if periods.count > 0{
            if periods[periods.count - 1].endingTime == nil && periods[periods.count - 1].startingTime != nil{
                timerIsRunning = true
            }else{
                timerIsRunning = false
            }
            
            
            var totalTimeInterval:TimeInterval = 0.0
            for period in periods{
                if period.uid != nil && period.startingTime != nil{
                    if let endingTime = period.endingTime {
                        totalTimeInterval += endingTime.timeIntervalSince(period.startingTime!)
                    }
                }
            }
            totalTime = TimeFormatter().secondsToHoursMinutesSeconds(interval: totalTimeInterval)
        }else{
            timerIsRunning = false
            totalTime = "let's get started!"
        }
        
    }
    
    func startButtonPressed(){
        if periods.count > 0{
            if periods[periods.count - 1].endingTime != nil{
                timerIsRunning = true
                //now save
                
                let newPeriod = Periods(context: managedObjectContext)
                newPeriod.startingTime = Date()
                newPeriod.uid = UUID()
                PersistenceController.shared.save()
            }
        }else{
            timerIsRunning = true
            //now save
            
            let newPeriod = Periods(context: managedObjectContext)
            newPeriod.startingTime = Date()
            newPeriod.uid = UUID()
            
            PersistenceController.shared.save()
        }
    }
    
    func endButtonPressed(){
        
        if periods.count > 0 {
            if periods[periods.count - 1].startingTime != nil{
                timerIsRunning = false
                
                periods[periods.count - 1].endingTime = Date()
                
                PersistenceController.shared.save()
                currentTimer = "0"
            }else{
                showSpamAlert = true
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

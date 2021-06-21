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
    //
    //    private var items: FetchedResults<Item>
    
    
    @State var timerIsRunning = false
    @State var totalTime:String = ""
    @State var currentTimer:String = ""
    
    var body: some View {
        
        
        
        return Group {
            if !timerIsRunning{
                //when the timer is not running
                VStack{
                    
                    Spacer()
                    
                    Text(totalTime != "" ? totalTime : "3213 hours 5 minutes")
                        .font(.title)
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        timerIsRunning = true
                    }) {
                        ZStack{
                            
                            Text("Start")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.blue)
                            
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 100, height: 100, alignment: .center)
                                .shadow(color: .black, radius: 2, x: 2, y: 2)
                                .opacity(0.5)
                            
                        }
                    }
                    
                    
                    Spacer()
                    
                }
            }else{
                VStack{
                    
                    Spacer()
                    
                    Text(currentTimer != "" ? currentTimer : "1:45:24")
                        .font(.title)
                    
                    Spacer()
                    Spacer()
                    
                    HStack{
                        
                        Spacer()
                        Spacer()
                        
                        ZStack{
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x: 2, y: 2)
                                .opacity(0.5)
                            Text("Pause")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            //MARK: Remeber to update total number
                            
                            timerIsRunning = false
                        }){
                            ZStack{
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2, x: 2, y: 2)
                                    .opacity(0.5)
                                Text("Stop")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            }
                        }
                        
                        
                        Spacer()
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

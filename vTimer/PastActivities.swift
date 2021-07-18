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
    let persistenceController = PersistenceController.shared
    
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
    
    
    
    @State var showClearAllAlert = false
    
    @State var timerColor:Color = Color.blue
    
    @State var showSheet: Bool = false
    
    @State var periodID:UUID?
    
    @State var easterEggCount = 0
    
    @State var easterEggAlertIsPresent = false
    
    
    var body: some View {
        
        
        NavigationView {
            Form{
                List(periods, id:\.self){ period in
                    
                    if period.endingTime != nil && period.startingTime != nil &&
                        period.uid != nil{
                        
                        NavigationLink(
                            destination: PeriodDetailView(uid: period.uid!)
                                .navigationTitle("Details")
                                .environment(\.managedObjectContext, persistenceController.container.viewContext),
                            label: {
                                PeriodRowView(period: period)
                            })
                    }else{
                        Spacer()
                        
                        Button(action: {
                            timerColor = Color.random
                            
                            if easterEggCount > 14{
                                easterEggCount = -112
                                easterEggAlertIsPresent = true
                                
                            }else{
                                easterEggCount += 1
                            }
                            
                            
                        }, label: {
                            
                            HStack{
                                Image(systemName: "timer.square")
                                    .font(.title)
                                    .foregroundColor(timerColor)
                                
                                Text("Timer Is Running")
                                    .bold()
                                    .foregroundColor(timerColor)
                                    .padding()
                                    .font(.callout)
                            }
                        }).alert(isPresented: $easterEggAlertIsPresent, content: {
                            
                            Alert(title: Text(":)"), message: Text("You have found an Easter egg"), dismissButton: .default(Text("lol")))
                            
                        })
                        
                        
                        Spacer()
                        
                        
                        
                    }
                }
                
            }.navigationBarTitle("History")
            .navigationBarItems(trailing: Button(action: {
                showClearAllAlert = true
            }, label: {
                Text("Clear All")
            }))
            .alert(isPresented: $showClearAllAlert, content: {
                
                Alert(title: Text("Delete All?"), message: Text("All iCloud History Will Be Cleared. You Cannot Undo This Action"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete All"), action: {
                    for period in periods{
                        managedObjectContext.delete(period)
                        
                    }
                    PersistenceController.shared.save()

                }))
                
            })
        }
        
        
        
        
        
        //            List(periodsFetchedResults,id:\.self){ period in
        //                Text("A List Item")
        //                Text("A Second List Item")
        //                Text("A Third List Item")
        //            }
    }
    
    
    
    
    
    
    
}


struct PastActivities_Previews: PreviewProvider {
    static var previews: some View {
        PastActivities().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
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

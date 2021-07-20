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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
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
    
    @State var timerColor:Color = Color.random
    
    @State var showSheet: Bool = false
    
    @State var periodID:UUID?
    
    @State var easterEggCount = 0
    
    @State var deleteIncompletePeriod = false
    
    
    var body: some View {
        
        
        NavigationView {
            Form{
                List(periods.indices , id:\.self){ index in
                    
                    let period = periods[index]
                    
                    if period.endingTime != nil && period.startingTime != nil &&
                        period.uid != nil{
                        
                        NavigationLink(
                            destination: PeriodDetailView(filterUID: period.uid!)
                                .navigationTitle("Details")
                                .environment(\.managedObjectContext, persistenceController.container.viewContext),
                            label: {
                                if period.uid != nil && period.startingTime != nil && period.endingTime != nil{
                                    PeriodRowView(period: period)
                                    
                                }
                                
                            })
                    }else{
                        Spacer()
                        
                        if index == 0{
                            Button(action: {
                                
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
                            })
                            .alert(isPresented: $deleteIncompletePeriod, content: {
                                
                            })
                        }
                        
                        //
                        
                        
                        Spacer()
                        
                        
                        
                    }
                }
                
            }.navigationBarTitle("History")
            .navigationBarItems(trailing: Button(action: {
                showClearAllAlert = true
            }, label: {
                Text("Delete All")
                    .foregroundColor(.red)
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

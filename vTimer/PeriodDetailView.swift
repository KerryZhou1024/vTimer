//
//  PeriodDetailView.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/29/21.
//

import SwiftUI

struct PeriodDetailView: View {
    
    @State var uid:UUID
    
    @State var targetPeriodStartingTime:Date = Date()
    @State var targetPeriodEndingTime:Date = Date()
    @State var targetPeriodIndex = -1;
    
    @State var deleteActionAlertPresent = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        entity: Periods.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Periods.startingTime, ascending: false)
        ],
        animation : .default
    ) var periods: FetchedResults<Periods>
    
    
    var body: some View {
        Form{
            Section(header: Text("About")){
                HStack {
                    Text("Start:")
                    Spacer()
                    Text(TimeFormatter().dateToReadableDate(date: targetPeriodStartingTime))
                }
                
                HStack {
                    Text("End:")
                    Spacer()
                    Text(TimeFormatter().dateToReadableDate(date: targetPeriodEndingTime))
                }
                
                HStack {
                    Text("Interval:")
                    Spacer()
                    Text(TimeFormatter().secondsToHoursMinutesSecondsLite(interval: targetPeriodEndingTime.timeIntervalSince(targetPeriodStartingTime)))
                }
                
            }
            
            Section(header: Text("Actions")) {
                
                Button(action: {
                    deleteActionAlertPresent = true
                }, label: {
                    Text("Delete This Period")
                        .foregroundColor(.red)
                }).alert(isPresented: $deleteActionAlertPresent, content: {
                    Alert(
                        title: Text("Delete this period?"),
                        message: Text("This period will be erased and will consequently change your total time count\n This action cannot be undone."),
                        primaryButton: .default(Text("Cancel")),
                        secondaryButton: .destructive(Text("Delete"), action: {
                            let period = periods[targetPeriodIndex]
                            managedObjectContext.delete(period)
                            PersistenceController.shared.save()
                            presentationMode.wrappedValue.dismiss()

                            
                        })
                    )
                })
            }
        }
        .onAppear(perform: {
            for (index, period) in periods.enumerated(){
                if period.endingTime != nil && period.startingTime != nil &&
                    period.uid != nil{
                    if period.uid == self.uid{
                        targetPeriodStartingTime = period.startingTime!
                        targetPeriodEndingTime = period.endingTime!
                        targetPeriodIndex = index
                        

                    }
                }
            }
        })
    }
    
}

struct PeriodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodDetailView(uid: UUID())
    }
}

//
//  PeriodDetailView.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/29/21.
//

import SwiftUI
import CoreData

struct PeriodDetailView: View {
    /*
    var predicate:String
    var wordsRequest : FetchRequest<Periods>
    var words : FetchedResults<Periods>{wordsRequest.wrappedValue}

        init(predicate:String){
            self.predicate = predicate
            self.wordsRequest = FetchRequest(entity: Periods.entity(), sortDescriptors: [], predicate:
                NSPredicate(format: "%K == %@", #keyPath(Periods),predicate))

        }
    
    */
    var fetchRequest: FetchRequest<Periods>
    
    var periods: FetchedResults<Periods>{
        fetchRequest.wrappedValue
    }
    
//    @State var uid:UUID
//
//    @State var targetPeriodStartingTime:Date = Date()
//    @State var targetPeriodEndingTime:Date = Date()
//    @State var targetPeriodIndex = -1;
    
    @State var titleAlertShouldPresent = false
    
    @State var targetPeriodTitle = ""
    
    @State var deleteActionAlertPresent = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    /*
    @FetchRequest(
        entity: Periods.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Periods.startingTime, ascending: false)
        ],

        animation : .default
    ) var periods: FetchedResults<Periods>
    */
    
    init(filterUID:UUID) {
        fetchRequest = FetchRequest<Periods>(entity: Periods.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Periods.startingTime, ascending: false)
        ], predicate: NSPredicate(format: "uid == %@", filterUID as CVarArg), animation: .default
        )
  
        
    }
    
    
    
    
    var body: some View {
        
//make if statement here.
        
        if fetchRequest.wrappedValue.count != 0{
            Form{
                Section(header: Text("About")){
                    
                    HStack {
                        Text("Title:")
                        Spacer()
                        TextField("Click Here To Add Title", text: $targetPeriodTitle) { isBegin in
                            if !isBegin{
                                if targetPeriodTitle != fetchRequest.wrappedValue[0].title{
                                    fetchRequest.wrappedValue[0].title = targetPeriodTitle
                                    PersistenceController.shared.save()
                                }
                            }
                        }
                        .onAppear(perform: {
                            if let title = fetchRequest.wrappedValue[0].title{
                                targetPeriodTitle = title
                            }
                        })
                        .multilineTextAlignment(.center)
                        

 
 
                            /*
                            .onChange(of: targetPeriodTitle, perform: { value in
                                for (_ , period) in periods.enumerated(){
                                    if period.uid == self.uid{
                                        period.title = targetPeriodTitle
                                        
                                    }
                                    
                                    
                                }
                                PersistenceController.shared.save()
                            })
     */
                    }
                    
                    
                    HStack {
                        Text("Start:")
                        Spacer()
                        Text(TimeFormatter().dateToReadableDate(date: fetchRequest.wrappedValue[0].startingTime!))
                    }
                    
                    HStack {
                        Text("End:")
                        Spacer()
                        Text(TimeFormatter().dateToReadableDate(date: fetchRequest.wrappedValue[0].endingTime!))
                    }
                    
                    HStack {
                        Text("Interval:")
                        Spacer()
                        Text(TimeFormatter().secondsToHoursMinutesSecondsLite(interval: fetchRequest.wrappedValue[0].endingTime!.timeIntervalSince(fetchRequest.wrappedValue[0].startingTime!)))
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
                            message: Text("This period will be erased and will consequently change your total time count.\n You cannot undo this action. This will be synced with your other devices."),
                            primaryButton: .default(Text("Cancel")),
                            secondaryButton: .destructive(Text("Delete"), action: {
                                
                                managedObjectContext.delete(fetchRequest.wrappedValue[0])
                                PersistenceController.shared.save()
                                presentationMode.wrappedValue.dismiss()
                                
                                
                            })
                        )
                    })
                }
            }
        }else{
            Text("No Selection")
                .font(.title)
                .bold()
        }
        
        
        /*
        .onAppear(perform: {
            for (index, period) in periods.enumerated(){
                if period.endingTime != nil && period.startingTime != nil &&
                    period.uid != nil && period.title != nil{
                    if period.uid == self.uid{
                        targetPeriodStartingTime = period.startingTime!
                        targetPeriodEndingTime = period.endingTime!
                        targetPeriodIndex = index
                        targetPeriodTitle = period.title!
                        
                    }
                }
            }
        })
 */
    }
    
}

struct PeriodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodDetailView(filterUID: UUID())
    }
}

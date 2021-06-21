//
//  PastActivities.swift
//  vTimer
//
//  Created by Kerry Zhou on 6/21/21.
//

import SwiftUI

struct PastActivities: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Periods.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Periods.startingTime, ascending: true)
        ],
        animation : .default
    ) var periods: FetchedResults<Periods>
    
    
    
    
    var body: some View {
        
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        
        
        
        
    }
}

struct PastActivities_Previews: PreviewProvider {
    static var previews: some View {
        PastActivities()
    }
}

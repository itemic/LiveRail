//
//  LiveBoardPickerButtonView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/22/21.
//

import SwiftUI



struct LiveBoardPickerButtonView: View {
    @Binding var station: Station?
    @State var active = false
    
    
    var body: some View {
        ZStack {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    
                        active = true
                    
                }) {
                    Text(LocalizedStringKey(station?.StationName.En ?? "Station"))
                }
                .buttonStyle(OpacityChangingButton(Color(UIColor.systemIndigo)))
                

                
                
                                    
            }
            .padding()
            .padding(.bottom, 15)
            .background(BlurView())
            
            
            
        }
            SlideoverSheetView(isOpen: $active) {
                StationSheetPickerView(title: "View Timetable", selectedStationObject: $station, color: Color(UIColor.systemIndigo), active: $active, icon: "list.bullet.rectangle")
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}



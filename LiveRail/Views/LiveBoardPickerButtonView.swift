//
//  LiveBoardPickerButtonView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/22/21.
//

import SwiftUI



struct LiveBoardPickerButtonView: View {
    @StateObject var data = HSRDataStore.shared
    @Binding var stn: String
    @State var active = false
    
    
    var body: some View {
        ZStack {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    
                        active = true
                    
                }) {
                            Text(LocalizedStringKey(data.stationName(from: stn) ?? "Station"))
                }
                .buttonStyle(OpacityChangingButton(Color(UIColor.systemIndigo)))
                

                
                
                                    
            }
            .padding()
            .padding(.bottom, 15)
            .background(BlurView())
            
            
            
        }
            SlideoverSheetView(isOpen: $active) {
                StationSheetPickerView(title: "View Timetable", selectedStation: $stn, color: Color(UIColor.systemIndigo), active: $active, icon: "list.bullet.rectangle")
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct LiveBoardPickerButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LiveBoardPickerButtonView()
//    }
//}

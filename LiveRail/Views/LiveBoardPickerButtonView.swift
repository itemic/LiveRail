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
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    
                        active = true
                    
                }) {
                            Text(LocalizedStringKey(data.stationName(from: stn) ?? "Station"))
                }
                .buttonStyle(OpacityChangingButton(.purple))
                .sheet(isPresented: $active) {
                                    StationListPickerSheetView(title: "View Timetable", stations: data.stations, selectedStation: $stn, color: .purple)

                }
                                    
            }
            .padding()
            .padding(.bottom, 15)
            .background(BlurView())
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct LiveBoardPickerButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LiveBoardPickerButtonView()
//    }
//}

//
//  PlanViewPickerButtonView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/22/21.
//

import SwiftUI

struct PlanViewPickerButtonView: View {
    @StateObject var data = HSRDataStore.shared
    @Binding var origin: String
    @Binding var destination: String
    
    @State var ooActive = false
    @State var ddActive = false
    
    @State var rotation: Double
    
//    @State var startingStation = ""
//    @State var endingStation = ""
    
    var body: some View {
        ZStack {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    
                        ooActive = true
                }) {
                    Text(LocalizedStringKey(data.stationName(from:origin) ?? "Origin"))
                        
                }
                .buttonStyle(OpacityChangingButton(.hsrColor))

                Button(action: {
                    sendHaptics()
                    flipStations()
                }) {
                    VStack {
                        VStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title2)
                                .foregroundColor(.hsrColor)
                                
                        }
                    }
                }
                Button(action: {
                    
                        ddActive = true
                    
                }) {
                    Text(LocalizedStringKey(data.stationName(from:destination) ?? "Destination"))
                }
                .buttonStyle(OpacityChangingButton(.hsrColor))

            }
            .padding()
            .padding(.bottom, 15)
            .background(BlurView())
        }
            SlideoverSheetView(isOpen: $ooActive) {
                StationSheetPickerView(title: "Origin", selectedStation: $origin, color: .hsrColor, active: $ooActive, icon: "tram.fill")
            }
            SlideoverSheetView(isOpen: $ddActive) {
                StationSheetPickerView(title: "Destination", selectedStation: $destination, color: .hsrColor, active: $ddActive, icon: "tram.fill")
            }
    }
        .edgesIgnoringSafeArea(.all)
    }
    
    func flipStations() {
        let temp = origin
        origin = destination
        destination = temp
        
        rotation += 180
    }
    
    func sendHaptics() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred(intensity: 1.0)
    }
}

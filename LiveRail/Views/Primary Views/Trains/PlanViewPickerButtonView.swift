//
//  PlanViewPickerButtonView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/22/21.
//

import SwiftUI

struct PlanViewPickerButtonView: View {
    @StateObject var data = HSRStore.shared
    @Binding var originObject: Station?
    @Binding var destinationObject: Station?
    
    @State var ooActive = false
    @State var ddActive = false
    
    @State var rotation: Double

    
    var body: some View {
        ZStack {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    
                        ooActive = true
                }) {
                    Text(LocalizedStringKey(originObject?.StationName.En ?? "Origin"))
                        
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
                    Text(LocalizedStringKey(destinationObject?.StationName.En ?? "Destination"))
                }
                .buttonStyle(OpacityChangingButton(.hsrColor))

            }
            .padding()
            .padding(.bottom, 15)
            .background(BlurView())
        }
            SlideoverSheetView(isOpen: $ooActive) {
                StationSheetPickerView(title: "Origin", selectedStationObject: $originObject, color: .hsrColor, active: $ooActive, icon: "tram.fill")
            }
            SlideoverSheetView(isOpen: $ddActive) {
                StationSheetPickerView(title: "Destination", selectedStationObject: $destinationObject, color: .hsrColor, active: $ddActive, icon: "tram.fill")
            }
    }
        .edgesIgnoringSafeArea(.all)
    }
    
    func flipStations() {
        let temp = originObject
        originObject = destinationObject
        destinationObject = temp
        
        rotation += 180
    }
    
    func sendHaptics() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred(intensity: 1.0)
    }
}

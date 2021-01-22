//
//  PlanViewPickerButtonView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/22/21.
//

import SwiftUI

struct PlanViewPickerButtonView: View {
    var data: HSRDataStore
    @Binding var origin: String
    @Binding var destination: String
    @Binding var oActive: Bool
    @Binding var dActive: Bool
    @State var rotation: Double
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    withAnimation {
                        oActive = true
                    }
                }) {
                    Text(data.stationName(from:origin) ?? "Origin")
                }
                .buttonStyle(OpacityChangingButton(.orange))
                Button(action: {
                    flipStations()
                }) {
                    VStack {
                        VStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.title)
                                .rotationEffect(Angle.degrees(rotation))
                                .animation(.easeOut)
                        }
                    }
                }
                Button(action: {
                    withAnimation {
                        dActive = true
                    }
                }) {
                    Text(data.stationName(from:destination) ?? "Destination")
                }
                .buttonStyle(OpacityChangingButton(.orange))
            }
            .padding()
            .padding(.bottom, 15)
            .background(BlurView())
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func flipStations() {
        let temp = origin
        origin = destination
        destination = temp
        
        rotation += 180
    }
}

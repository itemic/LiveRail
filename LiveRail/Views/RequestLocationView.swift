//
//  RequestLocationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//

import SwiftUI
import CoreLocation

struct RequestLocationView: View {
    @AppStorage("showNearestStation") var showNearestStation = true
    @ObservedObject var lm: LocationManager
    
    var status: CLAuthorizationStatus {
        return lm.status ?? .notDetermined
    }

    var body: some View {
        ZStack {
            
        VStack {
            Image(systemName: "checkerboard.rectangle").font(.title)
            Spacer()
                Text("Next Departure").font(.headline).foregroundColor(.primary)
            Spacer()
            Text("View upcoming departures from the station closest to you.").font(.caption)
                Spacer()
                if (status == .denied) {
                    Text("You'll need to enable Location Services in Settings.").font(.caption)
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)

                        }) {
                            Text("Go to Settings").bold().font(.subheadline)
                                .padding()
                        }
                        Spacer()
                        Button(action: {
                            showNearestStation = false
                        }) {
                            Text("Hide").font(.subheadline)
                                .padding()
                        }
                        Spacer()
                    }
                    
                } else {
                    Button("Enable") {
                        lm.requestPermission()
                    }.buttonStyle(CustomButtonStyle())
                    Spacer()
                    Button(action: {
                        showNearestStation = false
                    }) {
                        Text("Hide").font(.subheadline)
                            .padding()
                    }
                }
                
            }
                .padding(20)
                .background(BlurView())
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
//        .background(Color(UIColor.secondarySystemGroupedBackground))
//        .cornerRadius(10)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

        
    }
    
}


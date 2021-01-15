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
            
        
//        VStack(alignment: .leading) {
//            VStack {
//                HStack {
//                    Text("N")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(width: 20, height: 40, alignment: .center)
//                        .background(Color.blue)
//                        .clipShape(Rectangle())
//
//                    VStack(alignment: .leading) {
//                        Text("0000").font(.system(.body, design: .rounded))
//                            .redacted(reason: .placeholder)
//                        Text("Destination").bold().font(.body)
//                            .redacted(reason: .placeholder)
//                    }
//                    Spacer()
//                        Text("--:--").font(.system(.body, design: .monospaced))
//                            .redacted(reason: .placeholder)
//                }
//                Divider()
//                HStack {
//                    Text("S")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(width: 20, height: 40, alignment: .center)
//                        .background(Color.green)
//                        .clipShape(Rectangle())
//                    VStack(alignment: .leading) {
//                        Text("0000").font(.system(.body, design: .rounded))
//                            .redacted(reason: .placeholder)
//                        Text("Destination").bold().font(.body)
//                            .redacted(reason: .placeholder)
//                    }
//                    Spacer()
//                        Text("--:--").font(.system(.body, design: .monospaced))
//                            .redacted(reason: .placeholder)
//                }
//
//            }
//            Spacer()
//        }
        VStack {
            Image(systemName: "clock.arrow.2.circlepath").font(.title)
            Spacer()
                Text("Next Departure").font(.headline).foregroundColor(.primary)
            Spacer()
            Text("View upcoming departures from the station closest to you.").font(.caption)
                Spacer()
                if (status == .denied) {
                    Text("You'll need to enable Location Services in Settings.").font(.caption)
                    
                } else {
                    Button("Enable") {
                        lm.requestPermission()
                    }.buttonStyle(CustomButtonStyle())
                }
                Spacer()
                Button(action: {
                    showNearestStation = false
                }) {
                    Text("Hide").font(.subheadline)
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


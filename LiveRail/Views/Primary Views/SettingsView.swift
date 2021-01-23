//
//  MoreView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/13/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var data = HSRDataStore.shared
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    @AppStorage("showNearestStation") var showNearestStation = true
    @AppStorage("nextDepartureEntries") var nextDepartureEntries = 1
    
    @AppStorage("enableLocationFeatures") var enableLocationFeatures = false
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var lm = LocationManager.shared
    
    static let dateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()

    var body: some View {
        
        
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                    Text("Settings").font(.title).bold()
                        Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark").imageScale(.medium).foregroundColor(.gray)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                        }
                    }
                }
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $showAvailable, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "sparkles").font(.callout).foregroundColor(.yellow))
                            VStack(alignment: .leading) {
                                Text("Departed services")
                                Text("Show trains that have departed.").font(.caption2).foregroundColor(.secondary)

                            }
                            }
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $showArrivals, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "checkerboard.rectangle").font(.callout).foregroundColor(.purple))
                            VStack(alignment: .leading) {
                                Text("Arrivals")
                                Text("Show arrivals at terminus stations.").font(.caption2).foregroundColor(.secondary)
                            }
                            }
                        })
                    }


                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 28, height: 28)
                                .overlay(Image(systemName: "location.fill").font(.callout).foregroundColor(.blue))

                            VStack(alignment: .leading) {
                                Text("Location Features")
                                Text("Nearby station shortcuts").font(.caption2).foregroundColor(.secondary)
                            }
                            Spacer()
                            if let status = lm.status {
                                if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                                    Toggle("Location Features", isOn: $enableLocationFeatures)
                                        .labelsHidden()
                                } else if (status == .notDetermined) {
                                    Button(action: {
                                        lm.requestPermission()
                                    }) {
                                        Text("Enable")
                                            .padding(8)
                                            .background(Color.accentColor.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                    
                                } else {
                                    // declined
                                    Button(action: {
                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)

                                    }) {
                                        Text("Settings")
                                            .padding(8)
                                            .background(Color.accentColor.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            
                        }
                    }
                        if let status = lm.status {
                            if (status == .denied || status == .restricted) {
                                
                                Text("Visit location settings to enable location features").font(.caption)
                                    .padding(.top, 4)

                            }
                        }
                    }
                }.padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                
                
                VStack(alignment: .leading) {
                    Text("DEVELOPER").font(.caption).foregroundColor(.secondary)
                HStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 28, height: 28)
                            .overlay(Image(systemName: "calendar.badge.clock").font(.callout).foregroundColor(.red))

                        Text("Data Fetch Time")
                        Spacer()
                        Text(data.lastUpdateDate, style: .relative)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                }
                
                Spacer()

                
            }.padding()
        }.background(Color(UIColor.tertiarySystemFill))
        .edgesIgnoringSafeArea(.vertical)
        
        
    }
}
//

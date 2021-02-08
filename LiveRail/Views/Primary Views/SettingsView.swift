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
    @AppStorage("enableTimeWarp") var enableTimeWarp = false
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var lm = LocationManager.shared
    
    @State var showEasterEggAlert = false
    
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
                .padding(.bottom, 20)
                
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
                                        Toggle("Location-based features", isOn: $enableLocationFeatures)
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
                    VStack(spacing: 20) {
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.red.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "calendar.badge.clock").font(.callout).foregroundColor(.red))
                                
                                Text("Data update time")
                                Spacer()
                                Text(data.lastUpdateDate, style: .relative)
                            }
                        }
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color(UIColor.systemTeal).opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "network").font(.callout).foregroundColor(Color(UIColor.systemTeal)))
                                
                                VStack(alignment: .leading) {
                                    Text("Fetch data")
                                    Text("Get updated data from PTX").font(.caption2).foregroundColor(.secondary)
                                }
                                Spacer()
                                Button(action: {
                                    data.reload(client: .init())
                                }) {
                                    Text("Fetch")
                                        .foregroundColor(Color(UIColor.systemTeal))
                                        .padding(8)
                                        .background(Color(UIColor.systemTeal).opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Toggle(isOn: $enableTimeWarp, label: {
                                HStack {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(Color(UIColor.systemIndigo).opacity(0.2))
                                        .frame(width: 28, height: 28)
                                        .overlay(Image(systemName: "timelapse").font(.callout).foregroundColor(Color(UIColor.systemIndigo)))
                                VStack(alignment: .leading) {
                                    Text("Time Warp β")
                                    Text("Look into the future...").font(.caption2).foregroundColor(.secondary)

                                }
                                }
                            })
                        }
                        
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Link("Terms of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                .foregroundColor(.secondary).font(.caption)
                            Text(" and ").foregroundColor(.secondary).font(.caption)
                            Link("Privacy Policy", destination: URL(string: "https://itemic.github.io/puzzle/privacy.html")!)
                                .foregroundColor(.secondary).font(.caption)
                        }
                        Text("Disclaimer: All times are in local time").foregroundColor(.secondary).font(.caption)
                            .onTapGesture {
                                showEasterEggAlert = true
                            }
                            .alert(isPresented: $showEasterEggAlert, content: {
                                Alert(title: Text("Improved date/time functionality coming soon"), message: Text("This little disclaimer courtesy of Austin"), dismissButton: .default(Text("Thanks Austin!")))
                            })
                        Text("Data source: Taiwan PTX Transport API").foregroundColor(.secondary).font(.caption)
                    }
                }
                
                
                Spacer()
                
                
            }.padding()
        }.background(Color(UIColor.tertiarySystemFill))
        .edgesIgnoringSafeArea(.vertical)
        
        
    }
}
//

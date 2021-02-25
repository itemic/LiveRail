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
    @AppStorage("showArrDeptTimes") var showArrDeptTimes = false
    
    
    @AppStorage("showStopDots") var showStopDots = true
    @AppStorage("stationDotsChoice") var stationDotsChoice = 1
    
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
                        Text("Settings").font(Font.system(.title, design: .rounded)).bold()
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
                .padding(4)
                
                // First bunch
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $showAvailable, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.yellow)
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "sparkles").font(.system(size: 16)).foregroundColor(.white))
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
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.purple)
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "checkerboard.rectangle").font(.system(size: 16)).foregroundColor(.white))
                                VStack(alignment: .leading) {
                                    Text("Arrivals")
                                    Text("Show arrivals at terminus stations.").font(.caption2).foregroundColor(.secondary)
                                }
                            }
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $showArrDeptTimes, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.pink)
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "deskclock").font(.system(size: 16)).foregroundColor(.white))
                                VStack(alignment: .leading) {
                                    Text("ARR_DEPT_TIMES_TITLE")
                                    Text("ARR_DEPT_TIMES_DESCRIPTION").font(.caption2).foregroundColor(.secondary)
                                }
                            }
                        })
                    }
                    
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                
                Spacer()
                
                //MARK: Station dots
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $showStopDots.animation(), label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.green)
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "ellipsis").font(.system(size: 16)).foregroundColor(.white))
                                VStack(alignment: .leading) {
                                    Text("Station dots")
                                    Text("Display stopping stations at a glance.").font(.caption2).foregroundColor(.secondary)
                                    
                                }
                            }
                        })
                    }
                    
                    if (showStopDots) {
                    StationDotsSettingsView()
                    
                    }
                    
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                
                Spacer()
                
                
                //MARK: location
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "location.fill").font(.system(size: 16)).foregroundColor(.white))
                                
                                VStack(alignment: .leading) {
                                    Text("Location features")
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
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.red)
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "calendar.badge.clock").font(.system(size: 16)).foregroundColor(.white))
                                
                                Text("Data update time")
                                Spacer()
                                Text(data.lastUpdateDate, style: .relative)
                            }
                        }
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color(UIColor.systemTeal))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "network").font(.system(size: 16)).foregroundColor(.white))
                                
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
                        
                        
                        //TIME WARP
                        
//                        VStack(alignment: .leading, spacing: 4) {
//                            Toggle(isOn: $enableTimeWarp, label: {
//                                HStack {
//                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
//                                        .fill(Color(UIColor.systemIndigo).opacity(0.2))
//                                        .frame(width: 28, height: 28)
//                                        .overlay(Image(systemName: "timelapse").font(.system(size: 16)).foregroundColor(Color(UIColor.systemIndigo)))
//                                VStack(alignment: .leading) {
//                                    Text("Time Warp β")
//                                    Text("Look into the future...").font(.caption2).foregroundColor(.secondary)
//
//                                }
//                                }
//                            })
//                        }
                        
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Link("Terms of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                .foregroundColor(.secondary).font(.caption)
                            Text(" and ").foregroundColor(.secondary).font(.caption)
                            Link("Privacy Policy", destination: URL(string: "https://liverail.terrankroft.com/privacy")!)
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

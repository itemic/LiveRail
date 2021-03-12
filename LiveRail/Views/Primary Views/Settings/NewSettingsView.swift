//
//  NewSettingsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/12/21.
//

import SwiftUI

struct NewSettingsView: View {
    
    @StateObject var data = HSRStore.shared
    @EnvironmentObject var network: NetworkStatus
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    @AppStorage("showArrDeptTimes") var showArrDeptTimes = true
    @AppStorage("homeScreen") var homeScreen: RailViews = .plannerView
    
    @AppStorage("showStopDots") var showStopDots = true
    @AppStorage("stationDotsChoice") var stationDotsChoice = 1
    
    @AppStorage("enableLocationFeatures") var enableLocationFeatures = true
    
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var lm = LocationManager.shared
    var body: some View {
        NavigationView {
            List {
                
                if (!network.connected) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("NO_NETWORK_DETECTED").font(.title3).bold()
                            Text("NO_NETWORK_DESCRIPTION")
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.opacity(0.3))
                    .padding(.vertical)
                }
                
                Section {
                    
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showAvailable, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.yellow)
                                    .frame(width: 30, height: 30)
                                    .overlay(Image(systemName: "sparkles").font(.system(size: 16)).foregroundColor(.white))
                                Text("Departed services")
                            }
                        })
                        Text("Show trains that have departed.").font(.subheadline).foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showArrivals, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.purple)
                                    .frame(width: 30, height: 30)
                                    .overlay(Image(systemName: "checkerboard.rectangle").font(.system(size: 16)).foregroundColor(.white))
                                Text("Arrivals")
                            }
                        })
                        Text("Show arrivals at terminus stations.").font(.subheadline).foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showArrDeptTimes, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.pink)
                                    .frame(width: 30, height: 30)
                                    .overlay(Image(systemName: "deskclock").font(.system(size: 16)).foregroundColor(.white))
                                Text("ARR_DEPT_TIMES_TITLE")
                            }
                        })
                        Text("ARR_DEPT_TIMES_DESCRIPTION").font(.subheadline).foregroundColor(.secondary)
                    }
                    
                }
                
                
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(UIColor.systemIndigo))
                                .frame(width: 30, height: 30)
                                .overlay(Image(systemName: "house.fill").font(.system(size: 16)).foregroundColor(.white))
                            
                            VStack(alignment: .leading) {
                                Text("HOME_PAGE_SETTINGS_ENTRY")
                            }
                            Spacer()
                        }
                        Text("HOME_PAGE_SETTINGS_DESCRIPTION").font(.subheadline).foregroundColor(.secondary)
                        HStack(spacing: 12) {
                            Text("Departures")
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemIndigo).opacity(0.15))
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .font(homeScreen == .timetableView ? Font.body.bold() : .body)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(homeScreen == .timetableView ? Color(UIColor.systemIndigo) : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    homeScreen = .timetableView
                                }
                            Text("Trains")
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.hsrColor.opacity(0.15))
                                .foregroundColor(Color.hsrColor)
                                .font(homeScreen == .plannerView ? Font.body.bold() : .body)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(homeScreen == .plannerView ? Color.hsrColor : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    homeScreen = .plannerView
                                }
                        }
                        .padding(.vertical)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showStopDots, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.green)
                                    .frame(width: 30, height: 30)
                                    .overlay(Image(systemName: "ellipsis").font(.system(size: 16)).foregroundColor(.white))
                                Text("Station dots")
                            }
                        })
                        Text("Display stopping stations at a glance.").font(.subheadline).foregroundColor(.secondary)
                        if (showStopDots) {
                            StationDotsSettingsView()
                        }
                    }
                    
                }
                
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.blue)
                                    .frame(width: 30, height: 30)
                                    .overlay(Image(systemName: "location.fill").font(.system(size: 16)).foregroundColor(.white))
                                
                                VStack(alignment: .leading) {
                                    Text("Location features")
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
                        Text("Nearby station shortcuts").font(.subheadline).foregroundColor(.secondary)

                    }
                    
                }
                Group {
                    Text("$")
                    Text("bb")
                }
                
            }
            .listStyle(GroupedListStyle())
            //            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
                }
            })
        }
    }
}

//struct NewSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewSettingsView()
//    }
//}

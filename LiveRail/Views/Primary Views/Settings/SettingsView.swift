//
//  NewSettingsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/12/21.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var data = HSRStore.shared
    @StateObject var alertStore = AlertStore.shared
    @EnvironmentObject var network: NetworkStatus
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    @AppStorage("showArrDeptTimes") var showArrDeptTimes = true
    @AppStorage("showAvailabilityLines") var showAvailabilityLines = true
    @AppStorage("showServiceAlert") var showServiceAlert = true
    @AppStorage("homeScreen") var homeScreen: RailViews = .plannerView
    
    @AppStorage("showStopDots") var showStopDots = true
    @AppStorage("stationDotsChoice") var stationDotsChoice = 1
    
    @AppStorage("enableLocationFeatures") var enableLocationFeatures = true
    @AppStorage("preselectLocation") var preselect = true
    @Environment(\.presentationMode) var presentationMode
    @StateObject var lm = LocationManager.shared
    var body: some View {
        NavigationView {
            List {
                
                if (!network.connected) {
                    Group {
                        HStack {
                            Image(systemName: "wifi.exclamationmark")
                        VStack(alignment: .leading) {
                            
                            Text("NO_NETWORK_DETECTED").font(.headline).bold()
                            
                            Text("NO_NETWORK_DESCRIPTION").font(.subheadline).foregroundColor(.secondary)
                        }
                        }
                        
                    }
                }
                
                if (!alertStore.alertData.isEmpty) {
                    ForEach(alertStore.alertData, id: \.self) { alert in
                        if (alert.alertStatus != .normal) {
                            
                            NavigationLink(destination: AlertDetailView(alert: alert)) {
                            HStack {
                                Image(systemName: alert.alertStatus.icon)
                                    .foregroundColor(alert.alertStatus.color)
                                Text(LocalizedStringKey(alert.alertStatus.text))
                                    .bold()
                                    .foregroundColor(alert.alertStatus.color).brightness(-0.3)
                                Spacer()
                            }
                            }
                            
                            
                        }
                    }
                }
                
                Section(header: Text("Interface")) {
                    
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showAvailable, label: {
                            HStack {
                                Circle()
                                    .fill(Color.hsrColor)
                                    .frame(width: 32, height: 32)
                                    .padding(.vertical, 5)
                                    .overlay(Image(systemName: "tram").font(.system(size: 18)).foregroundColor(.white))
                                Text("Departed trains")
                            }
                            
                        })
                    }
                    
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showArrivals, label: {
                            HStack {
                                Circle()
                                    .fill(Color.hsrColor)
                                    .frame(width: 32, height: 32)
                                    .padding(.vertical, 5)
                                    .overlay(Image(systemName: "checkerboard.rectangle").font(.system(size: 18)).foregroundColor(.white))
                                Text("Arrivals")
                            }
                            
                        })
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Toggle(isOn: .constant(false), label: {
                            HStack {
                                Circle()
                                    .fill(Color.hsrColor)
                                    .frame(width: 32, height: 32)
                                    .padding(.vertical, 5)
                                    .overlay(Image(systemName: "rectangle.split.2x1.fill").font(.system(size: 18)).foregroundColor(.white))
                                
                                VStack(alignment: .leading) {
                                    Text("AVAILABILITY_LINES_SETTINGS")
                                    Text("Temporarily disabled").font(.caption2).foregroundColor(.secondary)
                                }
                            }
                            
                        })
                    }
                    .disabled(true)
                    
//                    VStack(alignment: .leading) {
//                        Toggle(isOn: $showServiceAlert, label: {
//                            HStack {
//                                Circle()
//                                    .fill(Color.hsrColor)
//                                    .frame(width: 32, height: 32)
//                                    .padding(.vertical, 5)
//                                    .overlay(Image(systemName: "exclamationmark.shield").font(.system(size: 18)).foregroundColor(.white))
//                                Text("NETWORK_ALERT_SETTINGS")
//                            }
//                            
//                        })
//                    }
                    
                    
                }
                
                
                
                
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .fill(Color(UIColor.systemIndigo))
                                .frame(width: 32, height: 32)
                                .padding(.vertical, 5)
                                .overlay(Image(systemName: "house.fill").font(.system(size: 18)).foregroundColor(.white))
                            Text("HOME_PAGE_SETTINGS_ENTRY")
                            Spacer()
                            
                        }
                        HStack {
                            Text("Departures")
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemIndigo).opacity(0.15))
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .font(homeScreen == .timetableView ? Font.subheadline.bold() : .subheadline)
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
                                .font(homeScreen == .plannerView ? Font.subheadline.bold() : .subheadline)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(homeScreen == .plannerView ? Color.hsrColor : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    homeScreen = .plannerView
                                }
                        }
                        .padding(.bottom, 5)
                        
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showStopDots, label: {
                            HStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 32, height: 32)
                                    .padding(.vertical, 5)
                                    .overlay(Image(systemName: "ellipsis").font(.system(size: 18)).foregroundColor(.white))
                                Text("Station dots")
                            }
                            

                        })
                        if (showStopDots) {
                            StationDotsSettingsView()
//                                .disabled(true)
                        }
                        
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        if let status = lm.status {
                            if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                                
                                VStack(alignment: .leading) {
                                    Toggle(isOn: $enableLocationFeatures, label: {
                                        HStack {
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 32, height: 32)
                                                .padding(.vertical, 5)
                                                .overlay(Image(systemName: "location.fill").font(.system(size: 18)).foregroundColor(.white))
                                            Text("Nearest station")
                                        }
                                        
                                    })
                                }
                                
                            } else if (status == .notDetermined) {
                                
                                HStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 32, height: 32)
                                        .padding(.vertical, 5)
                                        .overlay(Image(systemName: "location.fill").font(.system(size: 18)).foregroundColor(.white))
                                    Text("Nearest station")
                                    Spacer()
                                    
                                    
                                    Button(action: {
                                        lm.requestPermission()
                                    }) {
                                        Text("Enable")
                                            .padding(8)
                                            .foregroundColor(.blue)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                                
                                
                            } else {
                                // disabled
                                
                                HStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 32, height: 32)
                                        .padding(.vertical, 5)
                                        .overlay(Image(systemName: "location.fill").font(.system(size: 18)).foregroundColor(.white))
                                    VStack(alignment: .leading, spacing: 0) {
                                    Text("Request location")
                                        Text("Go to location settings").font(.caption)
                                    }
                                    Spacer()
                                    
                                    
                                    Button(action: {
                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                    }) {
                                        Text("Settings")
                                            .padding(8)
                                            .foregroundColor(.blue)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                                
                            }
                            //
                            if (enableLocationFeatures && (status == .authorizedAlways || status == .authorizedWhenInUse) ) {
                                VStack(alignment: .leading) {
                                    Toggle(isOn: $preselect, label: {
                                        HStack {
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 32, height: 32)
                                                .padding(.vertical, 5)
                                                .overlay(Image(systemName: "location.viewfinder").font(.system(size: 18)).foregroundColor(.white))
                                            Text("Preselect nearest station")
                                        }
                                        
                                    })
                                }
                            }
                        }
                    }
                    
                    
                }
                
                
                
                Section(footer: Text("SEAT_AVAIL_DESC")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .fill(Color(UIColor.systemTeal))
                                .frame(width: 32, height: 32)
                                .padding(.vertical, 5)
                                .overlay(Image(systemName: "square.and.arrow.down").font(.system(size: 18)).foregroundColor(.white))
                            Text("Last update")
                            Spacer()
                            Image(systemName: "circlebadge.fill")
                                .foregroundColor(data.initSuccess ? .green : .red)
                            Text(data.lastUpdateDate, style: .date)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .fill(Color(UIColor.systemTeal))
                                .frame(width: 32, height: 32)
                                .padding(.vertical, 5)
                                .overlay(Image(systemName: "network").font(.system(size: 18)).foregroundColor(.white))
                            Text("Fetch data")
                            Spacer()
                            Button(action: {
                                data.reload(client: .init(), force: true)
                            }) {
                                Text("Fetch")
                                    .foregroundColor(Color(UIColor.systemTeal))
                                    .padding(8)
                                    .background(Color(UIColor.systemTeal).opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .fill(Color(UIColor.systemTeal))
                                .frame(width: 32, height: 32)
                                .padding(.vertical, 5)
                                .overlay(Image(systemName: "studentdesk").font(.system(size: 18)).foregroundColor(.white))
                            
                            VStack(alignment: .leading) {
                                Text("FETCH_DATA_AVAILABILITY_TITLE")
                                Text("FETCH_DATA_AVAILABILITY_DESC").font(.caption2).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                data.fetchAllAvailability(client: .init())
                            }) {
                                Text("Update")
                                    .foregroundColor(Color(UIColor.systemTeal))
                                    .padding(8)
                                    .background(Color(UIColor.systemTeal).opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    
                }
                
                Section(header: Text("Miscellaneous")) {
                    Link("Terms of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    Link("Privacy Policy", destination: URL(string: "https://liverail.terrankroft.com/privacy")!)
                    NavigationLink(destination: DataDisclaimerView()) {
                        Text("About")
                    }
                    NavigationLink(destination: NewsView()) {
                        Text("HSR News/Updates")
                    }
                }
                
                
                
                
            }
            
            
        
            .listStyle(InsetGroupedListStyle())
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


//
//  MoreView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/13/21.
//

import SwiftUI

struct SettingsView: View {
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
    
    @State var showEasterEggAlert = false
    
    var body: some View {
        
        
        ScrollView {
            
            
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Settings").font(Font.system(.title)).bold()
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
                .padding(.horizontal)
                .padding(.top, 20)
                
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
                } else {
                    Spacer()
                }
                
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
                .padding(.horizontal)
                
                //MARK: Default View
                VStack(alignment: .leading, spacing: 20) {
                HStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(UIColor.systemIndigo))
                        .frame(width: 28, height: 28)
                        .overlay(Image(systemName: "house.fill").font(.system(size: 16)).foregroundColor(.white))
                    
                    VStack(alignment: .leading) {
                        Text("HOME_PAGE_SETTINGS_ENTRY")
                        Text("HOME_PAGE_SETTINGS_DESCRIPTION").font(.caption2).foregroundColor(.secondary)
                    }
                    Spacer()
                    
                }
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
                }
                
                
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                
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
                .padding(.horizontal)
                

                
                
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
                    
                    HStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(UIColor.systemYellow))
                                .frame(width: 28, height: 28)
                                .overlay(Image(systemName: "triangle.fill").font(.system(size: 16)).foregroundColor(.white))
                            
                            VStack(alignment: .leading) {
                                Text("FETCH_DATA_AVAILABILITY_TITLE")
                                Text("FETCH_DATA_AVAILABILITY_DESC").font(.caption2).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                data.fetchAllAvailability(client: .init())
                            }) {
                                Text("Update")
                                    .foregroundColor(Color(UIColor.systemOrange))
                                    .padding(8)
                                    .background(Color(UIColor.systemYellow).opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                
                
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
                        Text("TIME_ZONE_DISCLAIMER").foregroundColor(.secondary).font(.caption)
                            .onTapGesture {
                                showEasterEggAlert = true
                            }
                            .alert(isPresented: $showEasterEggAlert, content: {
                                Alert(title: Text("Improved date/time functionality coming soon"), message: Text("This little disclaimer courtesy of Austin"), dismissButton: .default(Text("Thanks Austin!")))
                            })
                        Text("Data source: Taiwan PTX Transport API").foregroundColor(.secondary).font(.caption)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
            }
            
        }.background(Color(UIColor.tertiarySystemFill))
        .edgesIgnoringSafeArea(.vertical)
        
        
    }
}
//

//
//  MoreView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/13/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var data: HSRDataStore
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("hideTerminus") var hideTerminus = false
    @AppStorage("showNearestStation") var showNearestStation = true
    @AppStorage("nextDepartureEntries") var nextDepartureEntries = 1
    
    @Environment(\.presentationMode) var presentationMode
    
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
                                Text("Hide departed services")
                            }
                            }
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $hideTerminus, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "checkerboard.rectangle").font(.callout).foregroundColor(.purple))
                            VStack(alignment: .leading) {
                                Text("Hide terminus services")
                                Text("Don't show arrivals at terminus stations.").font(.caption2).foregroundColor(.secondary)
                            }
                            }
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $showNearestStation, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "location.fill").font(.callout).foregroundColor(.blue))
                            VStack(alignment: .leading) {
                                Text("Next Departures")
                                Text("Location services required.").font(.caption2).foregroundColor(.secondary)
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

//
//  StationListPickerSheetView.swift
//  LiveRail
//
//  Created by Terran Kroft on 2/22/21.
//

import SwiftUI

struct StationListPickerSheetView: View {
    
    var title: String
    var stations: [Station] // can we use data
    @Binding var selectedStation: String
    @AppStorage("enableLocationFeatures") var enableLocationFeatures = false
    var color: Color
    @Environment(\.presentationMode) var presentationMode

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var lm = LocationManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // TITLE
                
                HStack {
                    Text(LocalizedStringKey(title)).font(.title).bold()
                        Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark").imageScale(.medium).foregroundColor(.primary)
                            .padding(5)
                            .background(Color.primary.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding()
                .frame(height: 75)
                .background(color)
                Spacer()
                VStack {
                   
                    Text("Select a station")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    // GRID of stations
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(stations) {station in
                            Button(action: {
                                selectedStation = station.StationID
                                // dismiss
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text(LocalizedStringKey(station.StationName.En))
                                    .font(.title3).bold()
                                    .padding(.vertical, 18)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(station.StationID == selectedStation ? color : color.opacity(0.2))
                                    )
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                    }
                    
                    if let status = lm.status {
                        if ((status == .authorizedAlways || status == .authorizedWhenInUse) && enableLocationFeatures) {
                            if let nearest = lm.closestStation(stations: stations) {
                                Button(action: {
                                    selectedStation = nearest.StationID
                                    // dismiss
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Label(
                                        title: {
                                            Text(LocalizedStringKey(nearest.StationName.En)).bold() },
                                        icon: {Image(systemName: "location.fill") }
                                    )
                                    .font(.title3)
                                    .padding(.vertical, 16)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(nearest.StationID == selectedStation ? color : color.opacity(0.2))
                                    )
                                        }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 20)
                                    
                                }
                            }
                        }
                    
                    
                    }
                .padding()
            }
        }
        }
    }



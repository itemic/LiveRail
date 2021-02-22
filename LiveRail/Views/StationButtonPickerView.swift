//
//  StationButtonPickerVIew.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct StationButtonPickerView: View {
    
    var title: String
    var stations: [Station]
    @Binding var selectedStation: String
    @Binding var isActive: Bool
    @AppStorage("enableLocationFeatures") var enableLocationFeatures = false
    var color: Color

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var lm = LocationManager.shared
    
    
    var body: some View {
        if (isActive) {
            GeometryReader { geo in
                VStack {
                    Text(LocalizedStringKey(title)).font(.title).bold()
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(stations) {station in
                            
                            Button(action: {
                                selectedStation = station.StationID
                                isActive = false
                            }) {
                                Text(LocalizedStringKey(station.StationName.En))
                                    .font(.title3).bold()
                                    .padding(.vertical, 16)
                                    .foregroundColor(Color.primary)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(station.StationID == selectedStation ? color : color.opacity(0.2))
                                    )
                            }
                            
                            
                            
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    }
                    
                    
                    if let status = lm.status {
                        if ((status == .authorizedAlways || status == .authorizedWhenInUse) && enableLocationFeatures) {
                            if let nearest = lm.closestStation(stations: stations) {
//                                Divider()
                    Button(action: {
                        selectedStation = nearest.StationID
                        
                        isActive = false
                    }) {
                        Label(
                            title: { Text(LocalizedStringKey(nearest.StationName.En)).bold() },
                            icon: { Image(systemName: "location.fill") }
                        )
                            
                            .font(.title3)
                            
                            .padding(.vertical, 16)
                            .foregroundColor(Color.primary)
                            .frame(maxWidth: .infinity)
                            .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(nearest.StationID == selectedStation ? color : color.opacity(0.2))
                            )
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                            
                        }
                }}
                    
                }
                .padding()
                .frame(width: geo.size.width, height: geo.size.height)
                .background(BlurView())
                .onTapGesture {
                    isActive = false
                }
                .transition(.scale)
            }
        } else {
            EmptyView()
        }
    }
}


//
//  StationButtonPickerVIew.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct StationSheetPickerView: View {
    @StateObject var data = HSRDataStore.shared
    var title: String
//    var stations: [Station] // can we use data // use data.stations
    @Binding var selectedStation: String
    @AppStorage("enableLocationFeatures") var enableLocationFeatures = false
    var color: Color
    @Binding var active: Bool
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var icon: String
    
    var lm = LocationManager.shared
    func sendHaptics() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred(intensity: 1.0)
    }
    var body: some View {
        VStack {
            header
            grid
            locations
            Spacer()
            Spacer().frame(height: UIScreen.main.bounds.height * 0.05)
        }
      
        
    }
    
    var header: some View {
        HStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                
                .fill(color)
                .frame(width: 48, height: 48)
                .overlay(Image(systemName: icon).font(.system(size: 24)).foregroundColor(.white)
                )
            VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey(title))
            .font(.title2).bold()
            Text(LocalizedStringKey(data.stationName(from: selectedStation) ?? "NO_SELECT"))
                .foregroundColor(.secondary)
                .font(.headline).bold()
            }
            .padding(.leading, 5)
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .contentShape(Circle())
                .frame(width: 38, height: 38)
                .overlay(Image(systemName: "xmark.circle").font(.system(size: 24)).foregroundColor(.secondary)
                ).onTapGesture {
                    active = false
                }
            
                
        }
        .padding(.vertical)
    }
    
    var grid: some View {
        LazyVGrid(columns: columns, alignment: .center) {
            ForEach(data.stations) {station in
                Button(action: {
                    selectedStation = station.StationID
                    sendHaptics()
                    // dismiss
                    active = false
                }) {
                    Text(LocalizedStringKey(station.StationName.En))
                        .font(.title3).bold()
//                                    .padding(.vertical, 12)
                        .foregroundColor(station.StationID == selectedStation ? .white : .primary)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(station.StationID == selectedStation ? color : color.opacity(0.3))
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
        }
    }
    
    var locations: some View {
        Group {
        if let status = lm.status {
            if ((status == .authorizedAlways || status == .authorizedWhenInUse) && enableLocationFeatures) {
                if let nearest = lm.closestStation(stations: data.stations) {
                    Button(action: {
                        selectedStation = nearest.StationID
                        sendHaptics()
                        // dismiss
                        active = false
                    }) {
                        Label(
                            title: {
                                Text(LocalizedStringKey(nearest.StationName.En)).bold() },
                            icon: {Image(systemName: "location.fill") }
                        )
                        .font(.title3)
                        .padding(.vertical, 16)
                        .foregroundColor(nearest.StationID == selectedStation ? .white : .primary)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(nearest.StationID == selectedStation ? color : color.opacity(0.3))
                        )
                            }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                        
                    }
                }
        } else {
            EmptyView()
        }
        }
    }
}

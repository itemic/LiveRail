//
//  StationDotsSettingsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 2/10/21.
//

import SwiftUI

struct StationDotsSettingsView: View {
    @AppStorage("stationDotsChoice") var stationDotsChoice = 1
    
    let EDGE_DESTINATION = 1
    let NORTH_SOUTH = 2
    let SOUTH_NORTH = 3
    
    
    var sharedEdge: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 7, height: 7)
            }
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
            }
            
//            Text("Same Direction").font(.caption)
        }
    }
    var northSouth: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
            }
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
            }
            
//            Text("North-South").font(.caption)
        }
        
    }
    var southNorth: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 7, height: 7)
            }
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 7, height: 7)
            }
            
//            Text("South-North").font(.caption)
        }

    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                sharedEdge
                    .padding(10)
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                                .stroke(stationDotsChoice == EDGE_DESTINATION ? Color.green : Color.clear))
                    .onTapGesture {
                        stationDotsChoice = EDGE_DESTINATION
                    }
                Spacer()
                northSouth
                    .padding(10)
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                                .stroke(stationDotsChoice == NORTH_SOUTH ? Color.green : Color.clear))
                    .onTapGesture {
                        stationDotsChoice = NORTH_SOUTH
                    }
                Spacer()
                southNorth
                    .padding(10)
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                                .stroke(stationDotsChoice == SOUTH_NORTH ? Color.green : Color.clear))
                    .onTapGesture {
                        stationDotsChoice = SOUTH_NORTH
                    }
                Spacer()
            }
            
            switch (stationDotsChoice) {
            case 1: // really should use ENUM here
                Text("DESCRIPTION_EDGE_DESTINATION")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            case 2:
                Text("DESCRIPTION_NORTH_SOUTH")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            case 3:
                Text("DESCRIPTION_SOUTH_NORTH")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            default:
                Text("")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
        }
    }
}

struct StationDotsSettingsView_Previews: PreviewProvider {
    @AppStorage("stationDotsChoice") static var stationDotsChoice = 1
    static var previews: some View {
        
        ZStack {
            Color(UIColor.tertiarySystemFill)
            StationDotsSettingsView()
                
                .background(Color(UIColor.white))
                .cornerRadius(10)
                .padding()
        }
    }
}

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
                Text("$S$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.northColor)
                    .frame(width: 7, height: 7)
                Text("$N$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
            }
            HStack(spacing: 4) {
                Text("$N$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.southColor)
                    .frame(width: 7, height: 7)
                Text("$S$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
            }
            
//            Text("Same Direction").font(.caption)
        }
    }
    var northSouth: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text("$N$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                Circle()
                    .fill(Color.northColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Text("$S$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
            }
            HStack(spacing: 4) {
                Text("$N$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.southColor)
                    .frame(width: 7, height: 7)
                Text("$S$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
            }
            
//            Text("North-South").font(.caption)
        }
        
    }
    var southNorth: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text("$S$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.northColor)
                    .frame(width: 7, height: 7)
                Text("$N$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
            }
            HStack(spacing: 4) {
                Text("$S$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                Circle()
                    .fill(Color.southColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.gray)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.hsrColor)
                    .frame(width: 7, height: 7)
                Text("$N$")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
            }
            
//            Text("South-North").font(.caption)
        }

    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 6) {
                
                sharedEdge
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(stationDotsChoice == EDGE_DESTINATION ? Color.hsrColor : Color.clear))
                    
                    .onTapGesture {
                        stationDotsChoice = EDGE_DESTINATION
                    }
//                Spacer()
                northSouth
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(stationDotsChoice == NORTH_SOUTH ? Color.hsrColor : Color.clear))
                    
                    .onTapGesture {
                        stationDotsChoice = NORTH_SOUTH
                    }
//                Spacer()
                southNorth
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(stationDotsChoice == SOUTH_NORTH ? Color.hsrColor : Color.clear))
                    .onTapGesture {
                        stationDotsChoice = SOUTH_NORTH
                    }
                
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

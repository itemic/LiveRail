//
//  TrainsRowView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/25/21.
//

import SwiftUI

struct TrainsRowView: View {
    
    var trainNo: String
    var origin: String
    var originTime: String
    var destination: String
    var destinationTime: String
    var standardAvailability: SeatAvailability
    var businessAvailability: SeatAvailability
    var departed: Bool
    
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(trainNo)
                        .font(Font.system(.headline).weight(.semibold).monospacedDigit())
                        .font(Font.system(.headline).monospacedDigit().weight(.semibold))
                    Spacer()
                    if (departed) {
                        Text("DEPARTED")
                            .font(Font.system(.caption).weight(.medium))
                            .foregroundColor(.red)
                            .padding(2)
                            .padding(.horizontal, 4)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(5)
                    }
                        AvailabilityIconView(text: "Standard", status: standardAvailability)
                        AvailabilityIconView(text: "Business", status: businessAvailability)
                    
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey(origin))
                            .font(.callout).foregroundColor(.secondary)
                        Text(originTime)
                            .font(Font.system(.title).monospacedDigit().weight(.semibold))
                    }
                    Spacer()
                    VStack {
                        Text("")
                            .font(.callout)
                        Text("→")
                            .font(.title)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(LocalizedStringKey(destination))
                            .font(.callout).foregroundColor(.secondary)
                        Text(destinationTime)
                            .font(Font.system(.title).monospacedDigit().weight(.regular))
                    }
                }
            }
            .padding(.horizontal, 5)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .background(Color(UIColor.secondarySystemGroupedBackground))
        }
        .padding(.leading, 10)
        .background(Color.hsrColor)
        .cornerRadius(5)
    }
}

struct TrainsRowView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            TrainsRowView(trainNo: "0123", origin: "Zuoying", originTime: "15:41", destination: "Yunlin", destinationTime: "16:25", standardAvailability: .available, businessAvailability: .available, departed: true).preferredColorScheme($0)
                .padding(.horizontal, 10)
        }
    }
}

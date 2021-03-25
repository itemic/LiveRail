//
//  DeparturesRowView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/25/21.
//

import SwiftUI

struct DeparturesRowView: View {
    var trainNo: String
    var destination: String
    var direction: String // abbreviation
    var departureTime: String
    var color: Color
    
    var departed: Bool
    var departing: Bool
    
    
    var body: some View {
            HStack{
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Circle()
                            .fill(color.opacity(0.1))
                            .frame(width: 18, height: 18)
                            .overlay(
                                Image(systemName: "\(direction.lowercased()).circle").font(Font.system(size: 18).weight(.medium)).foregroundColor(color)
                            )
  
                        Text(trainNo)
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
                        } else if (departing) {
                            Text("LEAVING SOON")
                                .font(Font.system(.caption).weight(.medium))
                                .foregroundColor(.orange)
                                .padding(2)
                                .padding(.horizontal, 4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                    HStack(alignment: .top) {
                        Text(LocalizedStringKey(destination))
                            .font(Font.system(.largeTitle).weight(.medium))
                        Spacer()
                        Text(departureTime)
                            .font(Font.system(.title, design: .monospaced).weight(.medium))
                            
                    }
                }
                .padding(.horizontal, 5)
                .padding(.top, 5)
                .padding(.bottom, 5)
                .background(Color(UIColor.secondarySystemGroupedBackground))
            }
            .padding(.leading, 10)
            .background(color)
            .cornerRadius(5)
    }
}

struct DeparturesRowView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            DeparturesRowView(trainNo: "0627", destination: "Zuoying", direction: "s", departureTime: "12:33", color: .southColor, departed: false, departing: true).preferredColorScheme($0)
                .padding(.horizontal, 10)
                }
        
        
    }
}

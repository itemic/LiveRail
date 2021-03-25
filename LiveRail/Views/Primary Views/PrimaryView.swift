//
//  PlannerHomeView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

enum StationButtonType: CaseIterable {
    case origin, destination
}

struct PrimaryView: View {
    @StateObject var data = HSRStore.shared
    @EnvironmentObject var network: NetworkStatus
    
    // stored as IDs 4-digit string
    @State var startingStationObject: Station?
    @State var endingStationObject: Station?
    @State var timetableStationObject: Station?
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("homeScreen") var homeScreen: RailViews = .plannerView
    @AppStorage("preselectLocation") var preselect = true
    @AppStorage("enableLocationFeatures") var enableLocationFeatures = true


    
    @State private var originIsActive = false
    @State private var destinationIsActive = false
    
    
    
    @State private var showingSettings = false
    @State private var currentView: RailViews = .plannerView
    
    @State private var showingTimetable: StationTimetable?
    @State private var showTest = false
    var lm = LocationManager.shared
    var nextUp: String {
        return lm.closestStation(stations: data.stations)?.StationName.En ?? "N/A"
    }

    @State private var offset = CGSize.zero


    
    var body: some View {
        
        ZStack {
            
            switch (currentView) {
            case .plannerView:  PlanView(startingStationObject: $startingStationObject, endingStationObject: $endingStationObject, originIsActive: $originIsActive, destinationIsActive: $destinationIsActive).environmentObject(network)
            case .timetableView:  LiveboardView(timetableStationObject: $timetableStationObject).environmentObject(network)
            }
            
            HeaderView(currentView: $currentView, showingSettings: $showingSettings)
                .environmentObject(network)
            
           
            
            
            
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { _ in
                    
                    if (self.offset.width > 100) {
                        if (currentView == .plannerView) {
                            withAnimation(Animation.default.speed(2)) {
                            currentView = .timetableView
                            }
                        }
                    } else if (self.offset.width < -100) {
                        if (currentView == .timetableView) {
                            withAnimation(Animation.default.speed(2)) {
                                currentView = .plannerView
                            }
                        }
                    }
                    self.offset = .zero
            
                }
        )
        .onAppear {
            currentView = homeScreen
            
            if let status = lm.status {
            
                if ((status == .authorizedAlways || status == .authorizedWhenInUse) && enableLocationFeatures && preselect) {
                    if (startingStationObject == nil) {
                    startingStationObject = lm.closestStation(stations: data.stations)
                    }
                    if (timetableStationObject == nil) {
                    timetableStationObject = lm.closestStation(stations: data.stations)
                    }
                    
                }
            }
        }
        .onChange(of: preselect) { new in
            if let status = lm.status {
            
                if ((status == .authorizedAlways || status == .authorizedWhenInUse) && enableLocationFeatures && preselect) {
                    if (startingStationObject == nil) {
                    startingStationObject = lm.closestStation(stations: data.stations)
                    }
                    if (timetableStationObject == nil) {
                    timetableStationObject = lm.closestStation(stations: data.stations)
                    }
                    
                }
            }
        }
        

        
        
        
        
        
    }
    

}




public struct CustomButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.body.weight(.medium))
            .padding(.vertical, 12)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                    .fill(Color.accentColor)
            )
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}

public struct OpacityChangingButton: ButtonStyle {
    var color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(Font.system(.title2).bold())
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(color))
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}

enum RailViews: Int, CaseIterable {
    case plannerView, timetableView
    
    var value: Int {
        switch(self) {
        case .timetableView: return 1
        case .plannerView:   return 2
        }
    }
}

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
    @ObservedObject var data: HSRDataStore
    @StateObject var queryVM = HSRQueryViewModel()
    
    // stored as IDs 4-digit string
    @State var startingStation = ""
    @State var endingStation = ""
    @State var timetableStation = ""
    @AppStorage("showAvailable") var showAvailable = false
    
    
    @State private var originIsActive = false
    @State private var destinationIsActive = false
    @State private var timetableIsActive = false
    
    
    @State private var showingSettings = false
    @State private var currentView: HSRViews = .plannerView
    
    @State private var showingTimetable: StationTimetable?
    @State private var selectedView: Int = 2
    @StateObject var lm = LocationManager.shared
    var nextUp: String {
        return lm.closestStation(stations: data.stations)?.StationName.En ?? "N/A"
    }

    

    var body: some View {
        
        ZStack {
            
            switch (selectedView) {
            
            case 3:  PlanView(vm: queryVM, data: data, startingStation: $startingStation, endingStation: $endingStation, originIsActive: $originIsActive, destinationIsActive: $destinationIsActive)

            case 2:  LiveboardView(data: data, timetableStation: $timetableStation, timetableIsActive: $timetableIsActive)

            default: EmptyView()
            }
            
//            if (currentView == .plannerView) {
//                PlanView(vm: queryVM, data: data, startingStation: $startingStation, endingStation: $endingStation, originIsActive: $originIsActive, destinationIsActive: $destinationIsActive)
//            } else {
//                LiveboardView(data: data, timetableStation: $timetableStation, timetableIsActive: $timetableIsActive)
//            }
//
            HeaderView(data: data, currentView: $currentView, showingSettings: $showingSettings, selectedView: $selectedView)
            
            
            //MARK: 2
            ZStack {
                StationButtonPickerView(title: "Origin", stations: data.stations, selectedStation: $startingStation, isActive: $originIsActive)
                    .edgesIgnoringSafeArea(.all)
                StationButtonPickerView(title: "Destination", stations: data.stations, selectedStation: $endingStation, isActive: $destinationIsActive)
                    .edgesIgnoringSafeArea(.all)
                StationButtonPickerView(title: "View Timetable", stations: data.stations, selectedStation: $timetableStation, isActive: $timetableIsActive)
                    .edgesIgnoringSafeArea(.all)
            }
            
            
        }
        
        
        
        
        
    }
    

}


// source: https://medium.com/dev-genius/blur-effect-with-vibrancy-in-swiftui-bada837fdf50
struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemUltraThinMaterial) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
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
                RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                    .fill(Color.accentColor)
            )
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}

public struct OpacityChangingButton: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}

enum HSRViews: String, CaseIterable {
    case plannerView, timetableView
    
    var string: String {
        switch(self) {
        case .plannerView:   return "Planner"
        case .timetableView: return "Timetable"
        }
    }
}

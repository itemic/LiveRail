//
//  TrainServiceView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TrainServiceSheetView2: View {
    var train: RailDailyTimetable
    
    @Binding var active: Bool
    
    @StateObject var vm = HSRTrainViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var header: some View {
        HStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                
                .fill(train.DailyTrainInfo.direction.color)
                .frame(width: 48, height: 48)
                .overlay(Text(LocalizedStringKey(train.DailyTrainInfo.direction.abbreviated)).foregroundColor(.white).font(.title2)
                )
            VStack(alignment: .leading, spacing: 0) {
                Text("\(train.DailyTrainInfo.TrainNo)")
                    .font(Font.system(.title2).monospacedDigit().weight(.bold))
                Text("\(train.DailyTrainInfo.StartingStationName.En.localized) → \(train.DailyTrainInfo.EndingStationName.En.localized)")
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
    
    var body: some View {
        VStack(spacing: 0) {
                

                header
            
            
            ScrollView(showsIndicators: false) {
                
                
                    VStack(spacing: 0) {
                        
                        
                        
                        ForEach(train.StopTimes, id: \.StopSequence) { stop in
                            
                            ServiceLineStationEntry2(stop: stop, vm: vm)
                            
                            //MARK: End of FOREACH
                        }
                    }
                    .padding()
                
                Text("NOT_LIVE").font(.caption2).foregroundColor(.gray).padding()
                
                
                
                
            }
            
            
            
            
        }
        .onAppear {
            vm.train = train
        }
        .onChange(of: train) { newTrain in
            vm.train = newTrain
        }
        
        
        
        
        
        
    }
}


struct ServiceLineStationEntry2: View {
    var stop: StopTime
    @StateObject var vm: HSRTrainViewModel
    @State var offset: Double = 0.0
    @State var showOverlay: Bool = false
    @State var trainAtThisStation: Bool = false
    @State var pulseAnimation = false
    @State var lineAnimation = true
    @AppStorage("showArrDeptTimes") var showArrDeptTimes = false
    
    var lineHeight: CGFloat = 50.0
    var lineWidth: CGFloat = 6.0
    var positionIndicatorHeight: CGFloat = 6.0
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var isTerminalStation: Bool {
        isEndingStation || isStartingStation
    }
    
    var isEndingStation: Bool {
        return stop.StationID == vm.train?.DailyTrainInfo.EndingStationID
    }
    
    var isStartingStation: Bool {
        return stop.StationID == vm.train?.DailyTrainInfo.StartingStationID
    }
    
    func calcTrainlineColor() -> Color {
        return vm.allDepartedStations.contains(stop) ? Color(UIColor.systemGray2) : .hsrColor
    }
    
    func calcTrainDotColor() -> Color {
        return vm.allDepartedStations.contains(stop) ? Color(UIColor.systemGray2) : .hsrColor
    }
    
    func stationTextColor() -> Color {
        return vm.allDepartedStations.contains(stop) ? Color.secondary.opacity(0.5) : .primary
    }
    
    func stationSecondaryTextColor() -> Color {
        return vm.allDepartedStations.contains(stop) ? Color.secondary.opacity(0.5) : .secondary
    }
    
    func calcOffset() -> Double {
        if (vm.trainIsAtAnyStation) {return 0}
        if (stop == vm.getTrainProgress?.0) {
            return vm.getTrainProgress?.1 ?? 1.0
        }
        return 0
    }
    
    func calcShowOverlay() -> Bool {
        return stop == vm.getTrainProgress?.0
    }
    
    func calcTrainAtThisStation() -> Bool {
        return vm.isTrainAtStation(stop)
    }
    
    var regularStationCircle: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 20, height: 20)
            .overlay(
                ZStack {
                    if (trainAtThisStation) {
                Circle()
                    .fill(calcTrainDotColor())
                    
                    .frame(width: 14, height: 14)
                    .scaleEffect(pulseAnimation ? 2 : 1)
                    .opacity(pulseAnimation ? 0.5 : 1)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).speed(1.5))
                    .onAppear {
                        pulseAnimation.toggle()
                    }
                    }
                Circle()
                    .stroke(calcTrainDotColor(), lineWidth: 4)
                    .background(Circle().fill(Color(UIColor.systemGray5)))
                    .frame(width: 14, height: 14)
                }
                    )
        
    }
    
    var terminalStationCircle: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 20, height: 20)
            .overlay(Circle()
            .strokeBorder(calcTrainDotColor(), lineWidth: 4)
            .background(Circle().fill(calcTrainDotColor()))
            .frame(width: 18, height: 18))
    }
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            HStack {
                if (isEndingStation) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 20, height: lineHeight)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 20, height: lineHeight)
                        .overlay(
                            ZStack {
                            VStack(spacing: 0) {
                                if (showOverlay) {
                                    Rectangle()
                                        
                                        .fill(Color(UIColor.systemGray2))
                                        
                                        .frame(width: lineWidth, height: lineHeight * CGFloat(offset))
                                    

                                        Rectangle()
                                            .fill(trainAtThisStation ? Color(UIColor.systemGray2) : vm.train?.DailyTrainInfo.direction.color ?? Color.white )
                                            .frame(width: lineWidth, height: positionIndicatorHeight)
                                            
                                            

                                            
                                    
                                    Rectangle()
                                        .fill(Color.hsrColor)
                                        .frame(width: lineWidth, height: lineHeight - (lineHeight * CGFloat(offset)))
                                    
                                    
                                } else {
                                    Rectangle()
                                        .fill(calcTrainlineColor())
                                        .frame(width: lineWidth, height: lineHeight + positionIndicatorHeight)
                                }
                                
                            
                            }

                        }
                           
                        )
                }
                
                Spacer()
            }
            
            
            
            
            HStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                    .overlay(
                        
                        HStack(alignment: .center) {
                            
                            if (isTerminalStation) {
                                terminalStationCircle
                            } else {
                                regularStationCircle
                            }
                            
                            Text(LocalizedStringKey(stop.StationName.En)).font(.headline).bold().foregroundColor(stationTextColor())
                            Spacer()
                            
                            
                            if (showArrDeptTimes) {
                                if (isStartingStation) {
                                    
                                    Text(stop.DepartureTime).font(Font.system(.headline).monospacedDigit()).bold().foregroundColor(stationTextColor())
                                } else if (isEndingStation) {
                                    Text(stop.ArrivalTime).font(Font.system(.headline).monospacedDigit()).foregroundColor(stationTextColor())
                                    Text(stop.DepartureTime).font(Font.system(.headline).monospacedDigit()).bold().foregroundColor(.clear)
                                } else {
                                    Text(stop.ArrivalTime).font(Font.system(.headline).monospacedDigit()).foregroundColor(stationSecondaryTextColor())
                                    Text(stop.DepartureTime).font(Font.system(.headline).monospacedDigit()).bold().foregroundColor(stationTextColor())
                                }
                            } else {
                                if (isStartingStation) {
                                    
                                    Text(stop.DepartureTime).font(Font.system(.headline).monospacedDigit()).bold().foregroundColor(stationTextColor())
                                } else if (isEndingStation) {
                                    Text(stop.ArrivalTime).font(Font.system(.headline).monospacedDigit()).foregroundColor(stationTextColor())
                                } else {
                                    Text(stop.DepartureTime).font(Font.system(.headline).monospacedDigit()).bold().foregroundColor(stationTextColor())
                                }
                            }
                           
                            
                            
                            
                                    
                        }
//                        .background(Color.yellow.opacity(0.2))
                        
                    )

            
                
            
            }
            
    }
        .onAppear() {
            self.offset = calcOffset()
            self.showOverlay = calcShowOverlay()
            self.trainAtThisStation = calcTrainAtThisStation()
        }
        .onReceive(timer) {_ in
            self.offset = calcOffset()
            self.showOverlay = calcShowOverlay()
            self.trainAtThisStation = calcTrainAtThisStation()
//            self.lineAnimation.toggle()
        }
}


}
//
//  TrainServiceView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TrainServiceView: View {
    var train: StationTimetable
    
    
    @StateObject var vm = HSRTrainViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Text(LocalizedStringKey(train.direction.abbreviated))
                        .font(Font.system(.title, design: .rounded).bold())
                        .foregroundColor(train.direction.color)
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(5)
                    VStack(alignment: .leading) {
                        Text("\(train.TrainNo)").font(Font.system(.headline, design: .rounded).monospacedDigit().weight(.semibold))
                            .foregroundColor(.white)
                        Text(train.EndingStationName.En.localized).font(.title2).bold().foregroundColor(.white)

                    }
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
                .background(train.direction.color)
            }
            ScrollView {
                Spacer()
                    .frame(height: 20)
                
                
                
                if let train = vm.train {
                    VStack(spacing: 0) {
                        
                        ForEach(train.StopTimes, id: \.StopSequence) { stop in
                            
                            TrainServiceLineDrawingEntry(stop: stop, vm: vm)
                            
                            //MARK: End of FOREACH
                        }
                    }
                    .padding()
                }
                Text("NOT_LIVE").font(.caption2).foregroundColor(.gray).padding()
                
                
                
                
            }
        }
        
        .onAppear {
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        }
        
        
    }
}


struct TrainServiceLineDrawingEntry: View {
    
    var stop: StopTime
    @StateObject var vm: HSRTrainViewModel
    
    let stationHeight: Double = 60.0
    let barWidth: CGFloat = 20.0
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    @State var offset: Double = 0.0
    @State var stopMarkColor: Color = .gray
    @State var trainlineColor: Color = .gray
    @State var showOverlay: Bool = false
    @State var trainAtThisStation: Bool = false
    
    func calcTrainAtThisStation() -> Bool {
        return vm.isTrainAtStation(stop)
    }
    
    var dColor: Color {
        vm.train?.DailyTrainInfo.direction.color ?? .orange
    }
    
    func calcShowOverlay() -> Bool {
        return stop == vm.getTrainProgress?.0
    }
    
    func calcOffset() -> Double {
        if (vm.trainIsAtAnyStation) {return 0}
        if (stop == vm.getTrainProgress?.0) {
            return vm.getTrainProgress?.1 ?? 1.0
        }
        return 0
    }
    
    
    func calcStopMarkColor() -> Color {
        return vm.allDepartedStations.contains(stop) ? .gray : .white
    }
    
    func calcTrainlineColor() -> Color {
        return vm.allDepartedStations.contains(stop) ? .gray : .orange
    }
    
    
    
    var stopMark: some View {
        HStack(alignment: .center) {
            
            Rectangle().fill(Color.clear)
                .frame(height: 10)
                .overlay(
                    HStack {
                        VStack(alignment: .trailing) {
                            if (stop.ArrivalTime != stop.DepartureTime) {
                                Text("\(stop.ArrivalTime)").font(Font.system(.caption, design: .rounded).monospacedDigit())
                                    .foregroundColor(.secondary)
                            }
                            Text("\(stop.DepartureTime)").font(Font.system(.body, design: .rounded).monospacedDigit())
                        }
                        
                        if (stop.StationID == vm.train?.DailyTrainInfo.StartingStationID) {
                            Rectangle().fill(trainlineColor)
                                .frame(width: barWidth)
                                .offset(y: barWidth/4)
                                .overlay(
                                    Circle().fill(trainlineColor)
                                        .frame(width: barWidth, height: barWidth)
                                )
                                .overlay(
                                    Circle().fill(Color.white)
                                        .frame(width: 12, height: 12)
                                )
                        } else if (stop.StationID == vm.train?.DailyTrainInfo.EndingStationID){
                            Rectangle().fill(trainlineColor)
                                .frame(width: barWidth)
                                .offset(y: -barWidth/4)
                                .overlay(
                                    Circle().fill(trainlineColor)
                                        .frame(width: 20, height: 20)
                                ).overlay(
                                    Circle().fill(Color.white)
                                        .frame(width: 16, height: 16)
                                )
                        } else {
                            // Regular station
                            
                            
                            if (trainAtThisStation) {
                                
                                    
                                    Rectangle().fill(Color.clear)
                                
                                    .frame(width: barWidth)
                                    .overlay(
                                        Circle().fill(stopMarkColor)
                                            .frame(width: 20, height: 20)
                                    )
                                    .overlay(
                                        Circle().fill((vm.train?.DailyTrainInfo.direction.color)!)
                                            .frame(width: 10, height: 10)
                                    )
                                        .overlay(Circle()
                                                    .strokeBorder(showOverlay ? Color.primary : Color.clear , lineWidth: 2)
                                                    .background(Circle().foregroundColor(showOverlay ? vm.train?.DailyTrainInfo.direction.color : .clear))
                                                    .frame(width: 24, height: 24))
                            } else {
                                Rectangle().fill(trainlineColor)
                                    .frame(width: barWidth)
                                    .overlay(
                                        Circle().fill(stopMarkColor)
                                            .frame(width: 10, height: 10)
                                    )
                            }
                        }
                        Text(LocalizedStringKey(stop.StationName.En))
                            .font(.headline)
                        Spacer()
                    }
                )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                
                //MARK: Everything else
                if (stop.StationID != vm.train?.DailyTrainInfo.EndingStationID) {
                    
                    HStack(alignment: .top) {
                        Text("00:00").font(Font.system(.body, design: .rounded).monospacedDigit()).foregroundColor(.clear)
                        VStack(spacing: 0) {
                            Rectangle().fill(Color.clear)
                                .frame(width: barWidth, height: 10)
                            
                            if (showOverlay) {
                                VStack(spacing: 0) {
                                    Rectangle().fill(Color.gray.opacity(1))
                                        .frame(width: barWidth, height: CGFloat(stationHeight * offset))
                                    Rectangle().fill(Color.orange.opacity(1))
                                        .frame(width: barWidth, height: CGFloat(stationHeight - (stationHeight * offset)))
                                }
                            }
                            else {
                                Rectangle().fill(trainlineColor.opacity(1))
                                    .frame(width: barWidth, height: CGFloat(stationHeight))
                            }
                        }
                        Spacer()
                    }
                }
                stopMark
                if (!trainAtThisStation) {
                HStack(alignment: .top) {
                    Text("00:00").font(Font.system(.body, design: .rounded).monospacedDigit()).foregroundColor(.clear)
                    VStack(spacing: 0) {
                        Rectangle().fill(Color.clear)
                            .frame(width: barWidth)
                            .overlay(
                                ZStack {
                                    Circle()
                                        .strokeBorder(showOverlay ? Color.primary : Color.clear , lineWidth: 2)
                                        .background(Circle().foregroundColor(showOverlay ? vm.train?.DailyTrainInfo.direction.color : .clear))
                                        .frame(width: 24, height: 24)
                                }
                                .offset(y: CGFloat((stationHeight / -2) + offset * stationHeight))
                                .frame(width: 2*barWidth)
                                
                            )
                    }
                    Spacer()
                }
                }
                
                
            }
            .onReceive(timer) {_ in
                self.offset = calcOffset()
                self.stopMarkColor = calcStopMarkColor()
                self.trainlineColor = calcTrainlineColor()
                self.showOverlay = calcShowOverlay()
                self.trainAtThisStation = calcTrainAtThisStation()
            }
            .onAppear() {
                self.offset = calcOffset()
                self.stopMarkColor = calcStopMarkColor()
                self.trainlineColor = calcTrainlineColor()
                self.showOverlay = calcShowOverlay()
                self.trainAtThisStation = calcTrainAtThisStation()
            }
            
            
            
        }
        
        
        
        
    }
}

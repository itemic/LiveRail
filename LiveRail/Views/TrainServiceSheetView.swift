//
//  TrainServiceView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TrainServiceSheetView: View {
    var train: StationTimetable
    @Binding var active: Bool
    
    @StateObject var vm = HSRTrainViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var header: some View {
        HStack {    
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                
                .fill(train.direction.color)
                .frame(width: 48, height: 48)
                .overlay(Text(LocalizedStringKey(train.direction.abbreviated)).foregroundColor(.white).font(.title2)
                )
            VStack(alignment: .leading, spacing: 0) {
                Text("\(train.TrainNo)")
                    .font(Font.system(.title2).monospacedDigit().weight(.bold))
                Text(train.EndingStationName.En.localized)
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
            
            
            GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                
                if let train = vm.train {
                    VStack(spacing: 0) {
                        
                        ForEach(train.StopTimes, id: \.StopSequence) { stop in
                            
                            TrainServiceLineDrawingEntryX(stop: stop, vm: vm)
                            
                            //MARK: End of FOREACH
                        }
                    }
                    .padding()
                }
                Text("NOT_LIVE").font(.caption2).foregroundColor(.gray).padding()
                
                
                
                
            }
            
            
            }
            
        }
        
        
        .onAppear {
            print("fetching for the first time")
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        }
        .onChange(of: train) { newValue in
            vm.fetchTrainDetails(for: newValue.TrainNo, client: .init())
        }
        
        
        
        
    }
}



struct TrainServiceLineDrawingEntryX: View {
    
    var stop: StopTime
    @StateObject var vm: HSRTrainViewModel
    
    let stationHeight: Double = 40.0
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

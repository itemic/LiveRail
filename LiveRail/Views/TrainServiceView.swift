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
                    VStack {
                        Text("\(train.TrainNo) to \(train.EndingStationName.En)").font(.title).bold().foregroundColor(.white)
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
                Text("This view is not updated live.").font(.caption2).foregroundColor(.gray).padding()
                    
                
                
            
        }
        }
        
        .onAppear {
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        }

        
    }
}


struct TrainServiceLineDrawingEntry: View {
    
    var stop: StopTime
    var vm: HSRTrainViewModel
    
    let stationHeight: Double = 60.0
    
    func overlayValid() -> Bool {
        if ( stop == vm.getTrainProgress?.0 ) {
            return true
        }
        return false
    }
    
    func overlayCircleOffset() -> Double {
        if (vm.trainIsAtAnyStation) {return 0}
        if (stop == vm.getTrainProgress?.0) {
            let offset =  (vm.getTrainProgress?.1 ?? 1.0)
            return offset
        }
        return 0
    }
    
    var stopMarkColor: Color {
        return vm.allDepartedStations.contains(stop) ? .gray : .orange
    }
    
    var trainlineColor: Color {
        return vm.allDepartedStations.contains(stop) ? .gray : .orange
    }
    
    
    
    var stopMark: some View {
        HStack(alignment: .top) {
            
            Rectangle().fill(Color.clear)
                .frame(height: 7.5)
                .overlay(
                    HStack {
                        VStack {
                            if (stop.ArrivalTime != stop.DepartureTime) {
                                Text("\(stop.ArrivalTime)").font(Font.system(.body, design: .rounded).monospacedDigit())
                                    .foregroundColor(.secondary)
                            }
                            Text("\(stop.DepartureTime)").font(Font.system(.body, design: .rounded).monospacedDigit())
                        }
                        
                            Rectangle().fill(stopMarkColor.opacity(0.8))
                                .frame(width: 15, height: 7.5)

                        Text("\(stop.StationName.En)")
                        Spacer()
                    }
                )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                stopMark
                
                if (stop.StationID != vm.train?.DailyTrainInfo.EndingStationID) {
                    
                    HStack(alignment: .top) {
                        Text("00:00").font(Font.system(.body, design: .rounded).monospacedDigit()).foregroundColor(.clear)
                        VStack(spacing: 0) {
                            Rectangle().fill(Color.clear)
                                .frame(width: 7.5, height: 7.5)
                            
                            if (overlayValid()) {
                                VStack(spacing: 0) {
                                    Rectangle().fill(Color.gray.opacity(0.8))
                                    .frame(width: 7.5, height: CGFloat(stationHeight * overlayCircleOffset()))
                                    Rectangle().fill(Color.orange.opacity(0.8))
                                        .frame(width: 7.5, height: CGFloat(stationHeight - (stationHeight * overlayCircleOffset())))
                                }
                                .overlay(
                                    ZStack {
                                        Circle()
                                            .strokeBorder(overlayValid() ? Color.primary : Color.clear , lineWidth: 2)
                                            .background(Circle().foregroundColor(overlayValid() ? vm.train?.DailyTrainInfo.direction.color : .clear))
                                            .frame(width: 20, height: 20)
                                        Image(systemName: "tram.fill")
                                            .foregroundColor(overlayValid() ? .white : .clear)
                                            .font(.system(size: 10))
                                    }
                                    .offset(y: CGFloat((stationHeight / -2) + overlayCircleOffset() * stationHeight))
                                    .frame(width: 15)
                                    
                                )
                            } else {
                                Rectangle().fill(trainlineColor.opacity(0.8))
                                    .frame(width: 7.5, height: CGFloat(stationHeight))
                                    .overlay(
                                        ZStack {
                                            Circle()
                                                .strokeBorder(overlayValid() ? Color.primary : Color.clear , lineWidth: 2)
                                                .background(Circle().foregroundColor(overlayValid() ? vm.train?.DailyTrainInfo.direction.color : .clear))
                                                .frame(width: 20, height: 20)
                                            Image(systemName: "tram.fill")
                                                .foregroundColor(overlayValid() ? .white : .clear)
                                                .font(.system(size: 10))
                                        }
                                        .offset(y: CGFloat((stationHeight / -2) + overlayCircleOffset() * stationHeight))
                                        .frame(width: 15)
                                        
                                    )
                            }
                            
                            
                        }
                    
                        Spacer()
                    }
                }
                
            }
            
            
            
        }
        
    }
}

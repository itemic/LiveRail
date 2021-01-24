//
//  TrainServiceView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TrainServiceView: View {
    var train: StationTimetable
    
    @StateObject var vm =  HSRTrainViewModel()
    @Environment(\.presentationMode) var presentationMode
    
//    init(train: StationTimetable) {
//        self.train = train
//        self.vm = HSRTrainViewModel(with: train.TrainNo)
//    }

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
                ForEach(vm.train, id: \.self) { train in
                
                
                VStack(spacing: 0) {
                    
                        ForEach(train.StopTimes, id: \.StopSequence) { stop in
                            
                            TrainServiceLineDrawingEntry(stop: stop, train: train)
                            
                            //MARK: End of FOREACH
                        }
                    }
                    .padding()

                
            }
        }
        }
        
        .onAppear {
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        }

        
    }
}


struct TrainServiceLineDrawingEntry: View {
    
    var stop: StopTime
    var train: RailDailyTimetable
    
    func overlayValid(_ train: RailDailyTimetable, _ stop: StopTime) -> Bool {
        if ( stop == train.getTrainProgress()?.0 ) {
            return true
        }
        return false
    }
    
    func overlayCircleOffset(_ train: RailDailyTimetable, _ stop: StopTime) -> Double {
        if (train.trainIsAtStation()) {return 0}
        if (stop == train.getTrainProgress()?.0) {
            let offset =  (train.getTrainProgress()?.1 ?? 1.0)
            return offset
        }
        return 0
    }
    
    var stopMark: some View {
        HStack(alignment: .top) {
            
            Rectangle().fill(Color.clear)
                .frame(height: 7.5)
                .overlay(
                    HStack {
                        VStack {
                            if (stop.ArrivalTime != stop.DepartureTime) {
                                Text("\(stop.ArrivalTime)").font(Font.system(.body).monospacedDigit())
                                    .foregroundColor(.secondary)
                            }
                            Text("\(stop.DepartureTime)").font(Font.system(.body).monospacedDigit())
                        }
                        Rectangle().fill(Color.orange.opacity(0.8))
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
                
                if (stop.StationID != train.DailyTrainInfo.EndingStationID) {
                    
                    HStack(alignment: .top) {
                        Text("00:00").font(Font.system(.body).monospacedDigit()).foregroundColor(.clear)
                        VStack(spacing: 0) {
                            Rectangle().fill(Color.clear)
                                .frame(width: 7.5, height: 7.5)
                            Rectangle().fill(Color.orange.opacity(0.8))
                                .frame(width: 7.5, height: 100)
                                .overlay(
                                    ZStack {
                                        Circle()
                                            .strokeBorder(overlayValid(train, stop) ? Color.primary : Color.clear , lineWidth: 2)
                                            .background(Circle().foregroundColor(overlayValid(train, stop) ? train.DailyTrainInfo.direction.color : .clear))
                                            .frame(width: 25, height: 25)
                                        Image(systemName: "tram.fill")
                                            .foregroundColor(overlayValid(train, stop) ? .black : .clear)
                                            .font(.system(size: 10))
                                    }
                                    .offset(y: CGFloat(-50 + overlayCircleOffset(train, stop) * 100))
                                    .frame(width: 20, height: 20)
                                )
                        }
                    
                        Spacer()
                    }
                }
                
            }
            
            
            
        }
    }
}

//
//  TrainServiceView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TrainServiceView: View {
    var train: StationTimetable
    
    @ObservedObject var vm = HSRTrainViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    var prev: StopTime? {
        return vm.train!.prevStation()
    }
    
    var next: StopTime? {
        return vm.train!.nextStation()
    }
    
    func overlayCircleColor(_ stop: StopTime) -> Color {
        if (stop == vm.train!.getTrainProgress()?.0) {
            return .white
        }
        return .clear
    }
    
    func overlayValid(_ stop: StopTime) -> Bool {
        if ( stop == vm.train!.getTrainProgress()?.0 ) {
            return true
        }
        return false
    }
    
    func overlayCircleOffset(_ stop: StopTime) -> Double {
        if (vm.train!.trainIsAtStation()) { return 0}
        if (stop == vm.train!.getTrainProgress()?.0) {
            let offset =  (vm.train!.getTrainProgress()?.1 ?? 1.0)
            return offset
        }
        return 0
    }
    

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
                if (vm.train != nil) {
                VStack(spacing: 0) {
                    
                        ForEach(vm.train!.StopTimes, id: \.StopSequence) { stop in
                            
                            
                            VStack(alignment: .leading, spacing: 0) {
                                
                                
                                ZStack(alignment: .top) {
                                    
                                    
                                    HStack(alignment: .top) {
                                        
                                        Rectangle().fill(Color.clear)
                                            .frame(height: 7.5)
                                            //                                Text("00:00").font(Font.system(.body).monospacedDigit()).foregroundColor(.red)
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
                                    
                                    
                                    if (stop.StationID != vm.train!.DailyTrainInfo.EndingStationID) {
                                        
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
                                                                .strokeBorder(overlayValid(stop) ? Color.primary : Color.clear , lineWidth: 2)
                                                                .background(Circle().foregroundColor(overlayValid(stop) ? vm.train!.DailyTrainInfo.direction.color : .clear))
                                                                .frame(width: 25, height: 25)
                                                            Image(systemName: "tram.fill")
                                                                .foregroundColor(overlayValid(stop) ? .black : .clear)
                                                                .font(.system(size: 10))
                                                        }
                                                        .offset(y: CGFloat(-50 + overlayCircleOffset(stop) * 100))
                                                        .frame(width: 20, height: 20)
                                                    )
                                            }
                                            Spacer()
                                        }
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            
                            
                            
                            //MARK: End of FOREACH
                        }
                    }
                    .padding()
                }
                else {
                    Text("Nil error")
                }
                
            }
        }
        
        .onAppear {
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        }
        .onChange(of: vm.train, perform: { value in
            print("A change to \(train.TrainNo) -- \(value?.DailyTrainInfo.TrainNo  )")
        })
        
        
    }
}


struct StoppingStationRowItemView: View {
    var stop: StopTime
    
    
    var body: some View {
        Text("---")
    }
}

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
    
    // next
    func firstRectColor(_ stop: StopTime) -> Color {
        if (stop.StationID == vm.train!.DailyTrainInfo.StartingStationID) {return .clear}
        if (vm.train!.trainIsAtStation()) {return .accentColor}
        if (stop == next) {return vm.train!.DailyTrainInfo.direction.color}
        return .accentColor
    }
    
    // prev
    func secondRectColor(_ stop: StopTime) -> Color {
        if (stop.StationID == vm.train!.DailyTrainInfo.EndingStationID) {return .clear}
        if (vm.train!.trainIsAtStation()) {return .accentColor}
        if (stop == prev) {return vm.train!.DailyTrainInfo.direction.color}
        return .accentColor
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
            let offset =  (vm.train!.getTrainProgress()?.1 ?? 1.0) * 50.0
            print(offset)
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
            
            VStack(spacing: 0) {
            if (vm.train != nil) {
                
         
//                Text("Next station: \(vm.train!.nextStation()?.StationName.En ?? "-")")
//                Text("Prev station: \(vm.train!.prevStation()?.StationName.En ?? "-")")
                
                
                ForEach(vm.train!.StopTimes, id: \.StopSequence) { stop in
                    
                    
                    
                    HStack(alignment: .center) {

                        VStack {
                            
                            if (stop.ArrivalTime != stop.DepartureTime) {
                                Text(stop.ArrivalTime).font(.system(.body, design: .monospaced))
                                    .foregroundColor(.gray)
                            }
                            Text(stop.DepartureTime).font(.system(.body, design: .monospaced))
                        }
                        
                       
                        
                        
                        VStack(spacing: 0) {
                            
                            
                            Rectangle() // A, next
                                .fill(firstRectColor(stop))
                                .frame(width: 10)
                            
                            
                            Rectangle() // B, prev
                                .fill(secondRectColor(stop))
                                .frame(width: 10)
                            
                        }
                        .overlay(Circle()
                                    .strokeBorder(Color.primary, lineWidth: 2)
                                    .background(Circle().foregroundColor(Color(UIColor.systemBackground)))
//                                    .fill(Color(UIColor.systemBackground))
                                    .frame(width: (vm.train!.isEnding(stop: stop)) ? 18 : 12)
                        )
                        .overlay(ZStack {
                            Circle()
                                .strokeBorder(overlayValid(stop) ? Color.primary : Color.clear , lineWidth: 2)
                                .background(Circle().foregroundColor(overlayValid(stop) ? vm.train!.DailyTrainInfo.direction.color : .clear))
                                .frame(width: 25, height: 25)
//                                .offset(y: CGFloat(overlayCircleOffset(stop)))

                            Image(systemName: "tram.fill")
                                .foregroundColor(overlayValid(stop) ? .black : .clear)
                                .font(.system(size: 10))
                                
                        }
                                    
                                    
                                    .offset(y: CGFloat(overlayCircleOffset(stop)))
                                    .frame(width: 20, height: 20)
                        )
                        
                        
                        
                        Text(stop.StationName.En)
                            
                        Spacer()
                        
                        if (vm.train!.isTrainAtStation(stop: stop)) {
                            Text("Train is here!")
                        }

//                        Text("A")
                    }
                    .frame(height: 100)

                    

                    
                    //MARK: End of FOREACH
                }
            }
            }
            .padding()
        
        }
    }
        
        .onAppear {
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        }
        
        
    }
}


struct StoppingStationRowItemView: View {
    var stop: StopTime
//    var data: HSRDataStore
    
    var body: some View {
        Text("---")
    }
}

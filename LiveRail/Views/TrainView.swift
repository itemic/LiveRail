//
//  TrainView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct TrainView: View {
    var train: StationTimetable
    
    @ObservedObject var vm = HSRTrainViewModel()
    
    
    var body: some View {
        ZStack {
            
            List {
                
                if (vm.train != nil) {
                    
                    
                    Section(header: HStack {
                        Text("\(train.Direction == 0 ? "Southbound" : "Northbound")".uppercased())
                            .bold()
                            .padding(5)
                            .background(train.Direction == 0 ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }.padding(.top, 15)) {
                        ForEach(Array(vm.train!.StopTimes).sorted {
                            train.Direction == 0 ? $0.StopSequence < $1.StopSequence : $0.StopSequence > $1.StopSequence
                        }, id: \.StopSequence) { stop in
                            HStack(alignment: .center) {
                                if (stop.StationID == train.EndingStationID) {
                                    Image(systemName: "largecircle.fill.circle")
                                } else if (nextStop() != nil && stop == nextStop()) {
                                    Image(systemName: "chevron.\(train.Direction == 0 ? "down" : "up").circle.fill")
                                } else {
                                    Image(systemName: "\(stop.willDepartAfterNow ? "chevron.\(train.Direction == 0 ? "down" : "up").circle" : "circle.dashed")")
                                }
                                Text(stop.StationName.En)
                                    .fontWeight(stop == nextStop() ? .bold : .regular)
                                
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(stop.DepartureTime)").font(.system(.body, design: .monospaced))
                                    Text(readableTime(otherTime: stop.DepartureTime)).font(.caption2)
                                        .fontWeight(stop == nextStop() ? .bold : .regular)
                                    
                                }
                                
                            }
                            .foregroundColor(stop.willDepartAfterNow ? .primary : .secondary)
                            
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    
                    HStack {
                        VStack(spacing: -1) {
                            Text("\(train.TrainNo)").font(.headline)
                            Text("\(train.EndingStationName.En)").font(Font.system(.caption).smallCaps()).bold()
                        }
                        .padding(2)
                        .padding(.horizontal, 5)
                        
                        
                        .background(Color.orange)
                        
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    }
                }
            }
            .onAppear {
                print("pausing")
                LocationManager.shared.pause()
            }
            .onDisappear {
                print("resuming")
                LocationManager.shared.resume()
            }
            .listStyle(InsetGroupedListStyle())
            
            
            
        }
        .onAppear(perform: {
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        })
        .navigationTitle("\(train.TrainNo) to \(train.EndingStationName.En)")
    }
    

    
    func nextStop() -> StopTime? {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return vm.train!.StopTimes.first { a in
            dateFormatter.date(from: a.DepartureTime)!.time - now.time >= 0
            
        }
    }
    
    func readableTime(otherTime: String) -> String {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let departure = dateFormatter.date(from: otherTime) else { return "error" }
        
        let minutesUntilDeparture = departure.time - now.time
        let hoursUntilDeparture = minutesUntilDeparture / 60
        
        if (minutesUntilDeparture < 0) {
            return "departed"
        } else if (minutesUntilDeparture < 1) {
            return "under a minute"
        } else if (minutesUntilDeparture <= 60) {
            return "in \(minutesUntilDeparture)m"
        } else {
            return "in \(hoursUntilDeparture)h\(minutesUntilDeparture % 60)m"
        }
        
        //
        
    }
}

//struct TrainView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainView()
//    }
//}

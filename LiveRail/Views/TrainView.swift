//
//  TrainView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct TrainView: View {
    var train: StationTimetable
//    @ObservedObject var data: HSRDataStore
    @ObservedObject var vm = HSRTrainViewModel()
    

    var body: some View {
        ZStack {

            List {

                if (vm.train != nil) {
                    Section(header: Text("Details")) {

                        HStack {
                            Text("\(vm.train!.DailyTrainInfo.Direction == 0 ? "Southbound" : "Northbound")".uppercased())
                                .bold()
                                .padding(5)
                                .background(vm.train!.DailyTrainInfo.Direction == 0 ? Color.green : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }

                    }
                    Section(header: Text("Timetable")) {
                    ForEach(vm.train!.StopTimes, id: \.StopSequence) { stop in
                        HStack(alignment: .center) {
                            Text(stop.StationName.En)
                                .fontWeight(train.StationID == stop.StationID ? .bold : .regular)
                            Spacer()
                            VStack(alignment: .trailing) {
                            Text("\(stop.DepartureTime)").font(.system(.body, design: .monospaced))
                                .fontWeight(train.StationID == stop.StationID ? .black : .regular)
                                Text(readableTime(otherTime: stop.DepartureTime)).font(.caption2)
                            }

                        }
                        .foregroundColor(compareTime(otherTime: stop.DepartureTime) ? .primary : .secondary)

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
            .listStyle(InsetGroupedListStyle())



        }
            .onAppear(perform: {
                vm.fetchTrainDetails(for: train.TrainNo, client: .init())
            })
        .navigationTitle("\(train.TrainNo) to \(train.EndingStationName.En)")
    }
    
    func compareTime(otherTime: String) -> Bool {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let departure = dateFormatter.date(from: otherTime) else { return false }
        return now.time < departure.time
        
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
        } else if (minutesUntilDeparture <= 1) {
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

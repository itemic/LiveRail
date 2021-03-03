//
//  HSRWidget.swift
//  HSRWidget
//
//  Created by Terran Kroft on 3/2/21.
//

import WidgetKit
import SwiftUI
import Intents




struct TrainUpdateEntry: TimelineProvider {
    let data = HSRDataStore.shared
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> Void) {
//        let entry = data.stations
//            completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetContent>) -> Void) {
        
        let entry = WidgetContent(stations: data.stations)
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> WidgetContent {
        WidgetContent(stations: data.stations)
    }

}




@main
struct HSRWidget: Widget {
    let kind: String = "HSRWidget"

    public var body: some WidgetConfiguration {
      StaticConfiguration(
        kind: kind,
        provider: TrainUpdateEntry()
      ) { entry in
        EntryView(model: entry)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.orange, .hsrColor]), startPoint: .top, endPoint: .bottom))

      }
      .configurationDisplayName("Departures")
      .description("Get the next departures from a station.")
    }
    
}

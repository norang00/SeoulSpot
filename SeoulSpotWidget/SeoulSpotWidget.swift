//
//  SeoulSpotWidget.swift
//  SeoulSpotWidget
//
//  Created by Kyuhee hong on 4/23/25.
//

import WidgetKit
import SwiftUI

struct WidgetModel {
    let image: String
    let place: String
    let title: String
    let link: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), event: WidgetModel(image: "", place: "", title: "", link: ""), image: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), event: WidgetModel(image: "", place: "", title: "", link: ""), image: nil)
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        WidgetNetworkManager.shared.getTodayEvent { event in
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            
            ImageCacheManager.shared.downloadAndCacheImage(from: event.image) { image in
                for hourOffset in 0 ..< 5 {
                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                    var entry = SimpleEntry(date: entryDate, event: event, image: image)
                    entries.append(entry)
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
        
        let fallbackEvent = WidgetModel(image: "", place: "장소 없음", title: "행사 없음", link: "")
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, event: fallbackEvent, image: nil)
            entries.append(entry)
        }
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let event: WidgetModel
    let image: UIImage?
}

struct SeoulSpotWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("오늘의 이벤트✨")
                    .bold()
                    .padding(.bottom, 8)
                Text(entry.event.place)
                    .font(.caption2)
                Text(entry.event.title)
                    .font(.caption)
            }
            Spacer()
            VStack {
                if let image = entry.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 120)
                        .cornerRadius(10)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}

struct SeoulSpotWidget: Widget {
    let kind: String = "SeoulSpotWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SeoulSpotWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SeoulSpotWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("서울스팟 위젯")
        .description("오늘의 행사를 알려드릴게요!")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemSmall) {
    SeoulSpotWidget()
} timeline: {
    SimpleEntry(date: .now, event: WidgetModel(image: "", place: "place", title: "title", link: "link"), image: nil)
    SimpleEntry(date: .now, event: WidgetModel(image: "", place: "place", title: "title", link: "link"), image: nil)
}

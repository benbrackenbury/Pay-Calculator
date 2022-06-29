//
//  iOSWidgets.swift
//  iOSWidgets
//
//  Created by Ben Brackenbury on 29/06/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("hoursWorkedGlobal", store: UserDefaults(suiteName: "group.benbrackenbury.Pay-Calculator")) var hoursWorkedGlobal: Double = 66
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), hoursWorked: 4, hoursNeeded: 120)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), hoursWorked: hoursWorkedGlobal, hoursNeeded: 120)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), hoursWorked: hoursWorkedGlobal, hoursNeeded: 120)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let hoursWorked: Double
    let hoursNeeded: Double
}

struct iOSWidgetsEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        
        switch family {
        case .systemSmall:
            SmallWidget(entry: entry)
        case .systemMedium:
            MediumWidget(entry: entry)
        case .accessoryInline:
            InlineComplication(entry: entry)
        case .accessoryCircular:
            CircularComplication(entry: entry)
        case .accessoryRectangular:
            RectangularComplication(entry: entry)
        default:
            Text("Not implemented")
        }
    }
}

struct SmallWidget : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(entry.hoursWorked, format: .number)")
                .font(.system(size: 50, weight: .bold, design: .monospaced))
            Text("Hours Worked")
                .font(.callout)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }
}

struct MediumWidget : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("\(entry.hoursWorked, format: .number)")
                    .font(.system(size: 50, weight: .bold, design: .monospaced))
                    .padding(.trailing)
                Text("/")
                    .font(.system(size: 30, weight: .semibold, design: .monospaced))
                Text("120")
                    .font(.system(size: 30, weight: .semibold, design: .monospaced))
            }
            Text("Hours Worked")
                .font(.callout)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }
}

struct InlineComplication : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("\(entry.hoursWorked, format: .number) hours worked")
    }
}

struct CircularComplication : View {
    var entry: Provider.Entry
    
    var body: some View {
        Gauge(value: entry.hoursWorked, in: 0...120) {
            Text("")
        } currentValueLabel: {
            Text("\(entry.hoursWorked, format: .number)h")
        }
        .gaugeStyle(.accessoryCircular)
    }
}

struct RectangularComplication : View {
    var entry: Provider.Entry
    
    var body: some View {
        Gauge(value: entry.hoursWorked, in: 0...120) {
            Text("**\(entry.hoursWorked, format: .number)** hours worked")
        }
    }
}

@main
struct iOSWidgets: Widget {
    let kind: String = "iOSWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            iOSWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Hours Worked")
        .description("Displays the number of hours worked.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

struct iOSWidgets_Previews: PreviewProvider {
    static var previews: some View {
        iOSWidgetsEntryView(entry: SimpleEntry(date: Date(), hoursWorked: 4, hoursNeeded: 120))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}

//
//  iOSWidgets.swift
//  iOSWidgets
//
//  Created by Ben Brackenbury on 29/06/2022.
//

import WidgetKit
import SwiftUI

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
        iOSWidgetsEntryView(entry: SimpleEntry(date: Date(), hoursWorked: 4, hoursNeeded: 120, isGoal: true))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}

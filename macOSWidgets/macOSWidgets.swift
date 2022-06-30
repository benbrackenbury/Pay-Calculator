//
//  macOSWidgets.swift
//  macOSWidgets
//
//  Created by Ben Brackenbury on 29/06/2022.
//

import WidgetKit
import SwiftUI

struct macOSWidgetsEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        
        switch family {
        case .systemSmall:
            SmallWidget(entry: entry)
        case .systemMedium:
            MediumWidget(entry: entry)
        default:
            Text("Not implemented")
        }
    }
}

@main
struct macOSWidgets: Widget {
    let kind: String = "iOSWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            macOSWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Hours Worked")
        .description("Displays the number of hours worked.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

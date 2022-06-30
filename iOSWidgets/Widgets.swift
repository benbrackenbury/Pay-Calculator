//
//  Widgets.swift
//  Pay Calculator
//
//  Created by Ben Brackenbury on 30/06/2022.
//

import SwiftUI
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let hoursWorked: Double
    let hoursNeeded: Double
    let isGoal: Bool
}

struct Provider: TimelineProvider {
    @AppStorage("hoursWorkedGlobal", store: UserDefaults(suiteName: "group.benbrackenbury.Pay-Calculator")) var hoursWorkedGlobal: Double = 66
    @AppStorage("isGoalGlobal", store: UserDefaults(suiteName: "group.benbrackenbury.Pay-Calculator")) var isGoalGlobal: Bool = true
    @AppStorage("incomeGoalGlobal", store: UserDefaults(suiteName: "group.benbrackenbury.Pay-Calculator")) var incomeGoalGlobal: Double = 1170
    @AppStorage("payGlobal", store: UserDefaults(suiteName: "group.benbrackenbury.Pay-Calculator")) var payGlobal: Double = 10.5
    
    func calcHoursNeeded() -> Double {
        return ceil(incomeGoalGlobal / payGlobal)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), hoursWorked: 4, hoursNeeded: 120, isGoal: isGoalGlobal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), hoursWorked: hoursWorkedGlobal, hoursNeeded: calcHoursNeeded(), isGoal: isGoalGlobal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), hoursWorked: hoursWorkedGlobal, hoursNeeded: calcHoursNeeded(), isGoal: isGoalGlobal)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
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
                if entry.isGoal {
                    Text("/")
                        .font(.system(size: 30, weight: .semibold, design: .monospaced))
                    Text("\(entry.hoursNeeded, format: .number)")
                        .font(.system(size: 30, weight: .semibold, design: .monospaced))
                }
            }
            Text("Hours Worked")
                .font(.callout)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }
}

#if os(iOS)
struct InlineComplication : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("\(entry.hoursWorked, format: .number) hours worked")
    }
}

struct CircularComplication : View {
    var entry: Provider.Entry
    
    var body: some View {
        Gauge(value: entry.hoursWorked, in: 0...entry.hoursNeeded) {
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
        Gauge(value: entry.hoursWorked, in: 0...entry.hoursNeeded) {
            Text("**\(entry.hoursWorked, format: .number)** hours worked")
        }
    }
}
#endif

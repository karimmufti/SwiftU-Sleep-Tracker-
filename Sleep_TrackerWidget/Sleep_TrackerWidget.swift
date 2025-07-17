import WidgetKit
import SwiftUI

class SleepViewModel: ObservableObject {
    @Published var sleepMessage: AttributedString = ""
    @Published var motivationalMessage: AttributedString = ""

    init(hours: Double) {
        let sleepDuration = Measurement(value: hours, unit: UnitDuration.hours)
            .formatted(.measurement(width: .narrow))

        let message = "Less than \(sleepDuration) of sleep today."
        let motivation = "Get some rest!"

        sleepMessage = highlightAttributedString(message: message, highlights: [sleepDuration, "sleep"])
        motivationalMessage = highlightAttributedString(message: motivation, highlights: ["rest"])
    }

    func highlightAttributedString(message: String, highlights: [String]) -> AttributedString {
        var attributedMessage = AttributedString(message)
        attributedMessage.foregroundColor = .secondary

        for word in highlights {
            if let range = attributedMessage.range(of: word) {
                attributedMessage[range].foregroundColor = .primary
            }
        }

        return attributedMessage
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: .smiley)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        return Timeline(entries: [entry], policy: .atEnd)
    }
}

// MARK: - Widget View
struct Sleep_TrackerWidgetEntryView: View {
    var entry: Provider.Entry
    @StateObject private var viewModel = SleepViewModel(hours: 4.5)

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "moon.fill")
                .font(.title2)
                .foregroundStyle(.primary)
Spacer(minLength: 0)
            Text(viewModel.sleepMessage)
                .font(.system(size: 16, weight: .semibold))
Spacer(minLength: 0)

            Text(viewModel.motivationalMessage)
                .font(.system(size: 14, weight: .bold))
        }
        .font(.system(size: 18, weight: .bold))
        .foregroundStyle(.secondary)
        .colorScheme(.dark)
    }
}

struct Sleep_TrackerWidget: Widget {
    let kind: String = "Sleep_TrackerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Sleep_TrackerWidgetEntryView(entry: entry)
                .containerBackground(gradient, for: .widget)
        }
        .configurationDisplayName("Sleep Tracker")
        .description("Displays how much sleep you got and encourages you to rest.")
        .supportedFamilies([.systemSmall, .systemMedium])
        
    }

    var gradient: some ShapeStyle {
        LinearGradient(
            colors: [Color.purple, Color.indigo],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension ConfigurationAppIntent {
    static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    Sleep_TrackerWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}

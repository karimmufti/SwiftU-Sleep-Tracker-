//
//  Sleep_TrackerWidgetLiveActivity.swift
//  Sleep_TrackerWidget
//
//  Created by Karim Mufti on 7/17/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Sleep_TrackerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Sleep_TrackerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Sleep_TrackerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Sleep_TrackerWidgetAttributes {
    fileprivate static var preview: Sleep_TrackerWidgetAttributes {
        Sleep_TrackerWidgetAttributes(name: "World")
    }
}

extension Sleep_TrackerWidgetAttributes.ContentState {
    fileprivate static var smiley: Sleep_TrackerWidgetAttributes.ContentState {
        Sleep_TrackerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Sleep_TrackerWidgetAttributes.ContentState {
         Sleep_TrackerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Sleep_TrackerWidgetAttributes.preview) {
   Sleep_TrackerWidgetLiveActivity()
} contentStates: {
    Sleep_TrackerWidgetAttributes.ContentState.smiley
    Sleep_TrackerWidgetAttributes.ContentState.starEyes
}

//
//  Sleep_TrackerWidgetBundle.swift
//  Sleep_TrackerWidget
//
//  Created by Karim Mufti on 7/17/25.
//

import WidgetKit
import SwiftUI

@main
struct Sleep_TrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        Sleep_TrackerWidget()
        Sleep_TrackerWidgetControl()
        Sleep_TrackerWidgetLiveActivity()
    }
}

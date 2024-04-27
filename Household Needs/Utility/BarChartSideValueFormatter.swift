//
//  BarChartSideValueFormatter.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 27/04/24.
//

import Foundation
import DGCharts

public class BarChartSideValueFormatter: NSObject, AxisValueFormatter {
    public func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        return value.asThousand
    }
}

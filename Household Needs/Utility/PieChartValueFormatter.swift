//
//  PieChartValueFormatter.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 27/04/24.
//

import Foundation
import Charts
import DGCharts

public class PieChartValueFormatter: NSObject, ValueFormatter {
    public func stringForValue(_ value: Double, entry: DGCharts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: DGCharts.ViewPortHandler?) -> String {
        return value.asThousand
    }
}

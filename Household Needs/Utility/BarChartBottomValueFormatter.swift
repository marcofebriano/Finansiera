//
//  BarChartBottomValueFormatter.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 27/04/24.
//

import Foundation
import DGCharts

public class BarChartBottomValueFormatter: NSObject, AxisValueFormatter {
    public func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        let asInt = Int(value)
        switch asInt {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
}

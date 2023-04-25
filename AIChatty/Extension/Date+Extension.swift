//
//  Date+Extension.swift
//  AIChatty
//
import Foundation

extension Date {

  var timeInSecond: Int {
     let timeStamp = Int(timeIntervalSince1970)
     return timeStamp
   }

   var timeInMillSecond: Int {
     let millisecond = Int(round(timeIntervalSince1970*1000))
     return millisecond
   }
}

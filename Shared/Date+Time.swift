// source https://stackoverflow.com/questions/41646542/how-do-you-compare-just-the-time-of-a-date-in-swift

import Foundation

class Time: Comparable, Equatable {
init(_ date: Date) {
    //get the current calender
    let calendar = Calendar.current

    //get just the minute and the hour of the day passed to it
    let dateComponents = calendar.dateComponents([.hour, .minute], from: date)

        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60

        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }

    init(_ hour: Int, _ minute: Int) {
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = hour * 3600 + minute * 60

        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        self.hour = hour
        self.minute = minute
    }

    var hour : Int
    var minute: Int

    var date: Date {
        //get the current calender
        let calendar = Calendar.current

        //create a new date components.
        var dateComponents = DateComponents()

        dateComponents.hour = hour
        dateComponents.minute = minute

        return calendar.date(byAdding: dateComponents, to: Date())!
    }

    /// the number or seconds since the beggining of the day, this is used for comparisions
    private let secondsSinceBeginningOfDay: Int

    //comparisions so you can compare times
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
    }

    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
    }

    static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
    }


    static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
    }


    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
    }
}

extension Date {
    var time: Time {
        return Time(self)
    }
}

extension Time {
    static func - (lhs: Time, rhs: Time) -> Int {
        let lhsMin = lhs.hour * 60 + lhs.minute
        let rhsMin = rhs.hour * 60 + rhs.minute
        return lhsMin - rhsMin
    }
}

//https://sarunw.com/posts/getting-number-of-days-between-two-dates/
extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}

extension Date {
    static func compareNowTo(otherTime: String) -> Bool {
        let now = Date()
        guard let other = SharedDateFormatter.shared.date(from: otherTime) else { return false }
        return now.time < other.time
    }
    
    static func compare(now: Date = Date(), to otherTime: String) -> Bool {
        
        guard let other = SharedDateFormatter.shared.date(from: otherTime) else {return false}
        return now.time < other.time
    }
    
    static func compareEquality(otherTime: String) -> Bool {
        let now = Date()
        guard let other = SharedDateFormatter.shared.date(from: otherTime) else { return false }
        return now.time == other.time
    }
}

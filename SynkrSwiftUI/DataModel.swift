
import SwiftUI

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var phone: String?
    var profilePictureURL: String?
    var totalStreak: Int
    var monthlyStreak: Int
    var notificationsEnabled: Bool
    var awards: [Award]
}

struct Task: Identifiable, Codable {
    var id: String
    var userId: String
    var title: String
    var description: String?
    var date: Date
    var repeatFrequency: RepeatFrequency
    var priority: Priority
    var isCompleted: Bool
    var alert: Alert
    var category: Category
    var insights: [TaskInsight]?
}


struct TaskInsight: Identifiable, Codable {
    var id: String
    var taskId: String
    var tip: String
}

struct TimeCapsule: Identifiable, Codable {
    var id: String
    var userId: String
    var title: String
    var description: String
    var deadline: Date
    var priority: Priority
    var completionPercentage: Double
    var category: Category
    var tasks: [Task]  // Subtasks are just Tasks
}

struct Award: Identifiable, Codable {
    var id: String
    var name: String
    var dateEarned: Date
    var description: String
    var count: Int
}

enum RepeatFrequency: String, Codable, CaseIterable {
    case none, daily, weekly, monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

enum Priority: String, Codable, CaseIterable {
    case low, medium, high
}

enum Alert: String, Codable, CaseIterable {
    case none, fiveMinutes, tenMinutes, fifteenMinutes, thirtyMinutes, oneHour
}

enum Category: String, Codable, CaseIterable {
    case sports, study, work, meetings, habits, others
}

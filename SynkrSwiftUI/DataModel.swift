import UIKit
import Foundation

extension Date {
    /// Fetches the full week (Sunday to Saturday) for the current date.
    func fullWeekDates() -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: self)?.start ?? self
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    /// Formats a Date into a readable string (e.g., "16 Mar, Sun").
    func formattedString(format: String = "dd MMM, EEE") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    func fullFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    func yearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
}

func getMarch17Date() -> Date {
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = calendar.component(.year, from: Date()) // Current year
    dateComponents.month = 3
    dateComponents.day = 17

    return calendar.date(from: dateComponents) ?? Date() // Fallback to current date if nil
}

// MARK: - Enums
enum Priority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var tintColor: UIColor {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
}

enum Alert: String {
    case none = "None"
    case fiveMinutes = "5 minutes"
    case tenMinutes = "10 minutes"
    case fifteenMinutes = "15 minutes"
    case thirtyMinutes = "30 minutes"
    case oneHour = "1 hour"
}

enum Usage: String {
    case personal = "Personal"
    case work = "Work"
    case education = "Education"
}

enum Category: String, CaseIterable {
    case sports = "Sports"
    case study = "Study"
    case work = "Work"
    case meetings = "Meetings"
    case habits = "Habits"
    case others = "Others"
    
    var customCategory: CustomCategory {
        switch self {
        case .sports:
            return CustomCategory(
                category: self,
                categoryName: "Sports",
                categoryColor: UIColor.systemBlue,
                insights: "Stay active and healthy with sports-related tasks."
            )
        case .study:
            return CustomCategory(
                category: self,
                categoryName: "Study",
                categoryColor: UIColor.systemGreen,
                insights: "Focus on learning and personal growth."
            )
        case .work:
            return CustomCategory(
                category: self,
                categoryName: "Work",
                categoryColor: UIColor.systemRed,
                insights: "Manage your professional tasks efficiently."
            )
        case .meetings:
            return CustomCategory(
                category: self,
                categoryName: "Meetings",
                categoryColor: UIColor.systemOrange,
                insights: "Keep track of your scheduled meetings and events."
            )
        case .habits:
            return CustomCategory(
                category: self,
                categoryName: "Habits",
                categoryColor: UIColor.systemPurple,
                insights: "Build and maintain positive habits."
            )
        case .others:
            return CustomCategory(
                category: self,
                categoryName: "Others",
                categoryColor: UIColor.systemGray,
                insights: "Miscellaneous tasks that don't fit into other categories."
            )
        }
    }
    
    var taskImage: String {
        switch self {
        case .work: return "latch.2.case"
        case .study: return "books.vertical"
        case .sports: return "figure.run"
        case .meetings: return "person.line.dotted.person"
        case .habits: return "arrow.trianglehead.2.clockwise"
        case .others: return "Others"
        }
    }
}

struct CustomCategory {
    var category: Category
    var categoryName: String?
    var categoryColor: UIColor
    var insights: String
}

// MARK: - Models

struct User {
    var userId: UUID
    var name: String
    var email: String
    var password: String
    var phone: String
    var taskIds: [UUID] // Store task IDs instead of full tasks
    var timeCapsuleIds: [UUID] // Store time capsule IDs
    var totalStreak: Int
    var maxStreak: Int
    var settings: Settings
    var awardsEarned: [AwardsEarned] // Store award IDs instead of full awards
    
    init(userId: UUID = UUID(), name: String, email: String, password: String, phone: String, totalStreak: Int = 0, maxStreak: Int = 0, settings: Settings) {
        self.userId = userId
        self.name = name
        self.email = email
        self.password = password
        self.phone = phone
        self.taskIds = []
        self.timeCapsuleIds = []
        self.totalStreak = totalStreak
        self.maxStreak = maxStreak
        self.settings = settings
        self.awardsEarned = []
    }
}

struct Settings {
//    let profilePicture: String
    var usage: Usage
    var bedtime: String
    var wakeUpTime: String
    var notificationsEnabled: Bool
}

// Rename Task to UserTask to avoid conflict with Swift's concurrency Task
struct UserTask: Identifiable {
    var id = UUID()
    var taskName: String
    var description: String
    var startTime: String
    var endTime: String
    var date: Date // Single date for the task
    var priority: Priority
    var isCompleted: Bool
    var alert: Alert
    var category: Category
    var otherCategory: String?
    
    init(taskName: String, description: String, startTime: String, endTime: String, date: Date, priority: Priority, alert: Alert, category: Category, otherCategory: String? = nil, isCompleted: Bool = false) {
        self.taskName = taskName
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
        self.priority = priority
        self.isCompleted = isCompleted
        self.alert = alert
        self.category = category
        self.otherCategory = otherCategory
    }
    mutating func markAsCompleted() {
        self.isCompleted = true
    }
}

struct TimeCapsule {
    var capsuleId: UUID
    var capsuleName: String
    var deadline: Date
    var priority: Priority
    var description: String
    var completionPercentage: Double
    var category: Category
    var subtaskIds: [UUID] // Store subtask IDs instead of full subtasks
    
    init(capsuleId: UUID = UUID(), capsuleName: String, deadline: Date, priority: Priority, description: String, category: Category) {
        self.capsuleId = capsuleId
        self.capsuleName = capsuleName
        self.deadline = deadline
        self.priority = priority
        self.description = description
        self.completionPercentage = 0.0
        self.category = category
        self.subtaskIds = []
    }
    
    // Calculate completion percentage based on completed subtasks
    mutating func updateCompletionPercentage(subtasks: [Subtask]) {
        if subtasks.isEmpty {
            completionPercentage = 0.0
            return
        }
        
        let completedCount = subtasks.filter { $0.isCompleted }.count
        completionPercentage = Double(completedCount) / Double(subtasks.count) * 100.0
    }
}

struct Subtask {
    var subtaskId: UUID
    var subtaskName: String
    var description: String?
    var isCompleted: Bool
    
    init(subtaskId: UUID = UUID(), subtaskName: String, description: String? = nil, isCompleted: Bool = false) {
        self.subtaskId = subtaskId
        self.subtaskName = subtaskName
        self.description = description
        self.isCompleted = isCompleted
    }
    
    mutating func markAsCompleted() {
        self.isCompleted = true
    }
}

struct Award { //these are the awards that we have.
    var awardId: UUID
    var awardName: String
    var description: String
    
    init(awardId: UUID = UUID(), awardName: String, description: String) {
        self.awardId = awardId
        self.awardName = awardName
        self.description = description
    }
}

struct AwardsEarned {
    var id: UUID // Added for consistency
    var awardId: UUID // Renamed from award for consistency
    var dateEarned: Date
    
    
    init(id: UUID = UUID(), awardId: UUID, dateEarned: Date) {
        self.id = id
        self.awardId = awardId
        self.dateEarned = dateEarned
    }
}

class TaskDataModel {
    // Singleton instance
    static let shared = TaskDataModel()
    
    // Private properties
    private var users: [User] = []
    private var tasks: [UserTask] = []
    private var timeCapsules: [TimeCapsule] = []
    private var subtasks: [Subtask] = []
    private var awards: [Award] = []
    private var currentUser: User?
    
    // Private initializer for singleton
    private init() {
        setupSampleData()
    }
    
    // MARK: - User Management
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func getUser(by userId: UUID) -> User? {
        return users.first { $0.userId == userId }
    }
    
    func userExists(email: String) -> Bool {
        return users.contains { $0.email == email }
    }
    
    func validateUser(email: String, password: String) -> User? {
        let user = users.first { $0.email == email && $0.password == password }
        if user != nil {
            currentUser = user
        }
        return user
    }
    
    func addUser(_ newUser: User) -> Bool {
        if userExists(email: newUser.email) {
            print("Error: User with email \(newUser.email) already exists.")
            return false
        }
        users.append(newUser)
        print("User with email \(newUser.email) added successfully.")
        return true
    }
    
    func updateUser(_ user: User) {
        if let index = users.firstIndex(where: { $0.userId == user.userId }) {
            users[index] = user
            
            // If the updated user is the current user, update currentUser reference
            if currentUser?.userId == user.userId {
                currentUser = user
            }
        }
    }
    
    // MARK: - Task Management
    
    func getAllTasks(for userId: UUID) -> [UserTask] {
        return tasks.filter { task in
            if let user = getUser(by: userId) {
                return user.taskIds.contains(task.id)
            }
            return false
        }
    }
    
    func getTask(by taskId: UUID) -> UserTask? {
        return tasks.first { $0.id == taskId }
    }
    
    func addTask(_ task: UserTask, for userId: UUID) -> Bool {
        guard let userIndex = users.firstIndex(where: { $0.userId == userId }) else {
            print("Error: User not found with ID \(userId).")
            return false
        }
        
        // Add task to the tasks array
        tasks.append(task)
        
        // Update the user's taskIds array
        users[userIndex].taskIds.append(task.id)
        
        // Update current user if needed
        if currentUser?.userId == userId {
            currentUser?.taskIds.append(task.id)
        }
        
        return true
    }
    
    func updateTask(_ task: UserTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(with taskId: UUID, for userId: UUID) -> Bool {
        guard let userIndex = users.firstIndex(where: { $0.userId == userId }) else {
            print("Error: User not found with ID \(userId).")
            return false
        }
        
        // Remove the task from the tasks array
        tasks.removeAll { $0.id == taskId }
        
        // Remove the taskId from the user's taskIds array
        users[userIndex].taskIds.removeAll { $0 == taskId }
        
        // Update current user if needed
        if currentUser?.userId == userId {
            currentUser?.taskIds.removeAll { $0 == taskId }
        }
        
        return true
    }
    
    func getTasksByDate(for userId: UUID, date: Date) -> [UserTask] {
        return getAllTasks(for: userId).filter { task in
            let calendar = Calendar.current
            return calendar.isDate(task.date, inSameDayAs: date)
        }
    }
    
    func getTasksByCategory(for userId: UUID, category: Category) -> [UserTask] {
        return getAllTasks(for: userId).filter { $0.category == category }
    }
    
    func getTasksByPriority(for userId: UUID, priority: Priority) -> [UserTask] {
        return getAllTasks(for: userId).filter { $0.priority == priority }
    }
    
    func getCompletedTasks(for userId: UUID) -> [UserTask] {
        return getAllTasks(for: userId).filter { $0.isCompleted }
    }
    
    func getPendingTasks(for userId: UUID) -> [UserTask] {
        return getAllTasks(for: userId).filter { !$0.isCompleted }
    }
    
    func fetchOverdueTasks(for userId: UUID) -> [UserTask] {
        let today = Date()
        return getAllTasks(for: userId).filter { $0.date < today && !$0.isCompleted }
    }
    
    // MARK: - Time Capsule Management
    
    func getAllTimeCapsules(for userId: UUID) -> [TimeCapsule] {
        return timeCapsules.filter { capsule in
            if let user = getUser(by: userId) {
                return user.timeCapsuleIds.contains(capsule.capsuleId)
            }
            return false
        }
    }
    
    func getTimeCapsule(by capsuleId: UUID) -> TimeCapsule? {
        return timeCapsules.first { $0.capsuleId == capsuleId }
    }
    
    func addTimeCapsule(_ capsule: TimeCapsule, for userId: UUID) -> Bool {
        guard let userIndex = users.firstIndex(where: { $0.userId == userId }) else {
            print("Error: User not found with ID \(userId).")
            return false
        }
        
        // Add capsule to the timeCapsules array
        timeCapsules.append(capsule)
        
        // Update the user's timeCapsuleIds array
        users[userIndex].timeCapsuleIds.append(capsule.capsuleId)
        
        // Update current user if needed
        if currentUser?.userId == userId {
            currentUser?.timeCapsuleIds.append(capsule.capsuleId)
        }
        
        return true
    }
    
    func updateTimeCapsule(_ capsule: TimeCapsule) {
        if let index = timeCapsules.firstIndex(where: { $0.capsuleId == capsule.capsuleId }) {
            timeCapsules[index] = capsule
        }
    }
    
    func deleteTimeCapsule(with capsuleId: UUID, for userId: UUID) -> Bool {
        guard let userIndex = users.firstIndex(where: { $0.userId == userId }) else {
            print("Error: User not found with ID \(userId).")
            return false
        }
        
        // Remove the capsule from the timeCapsules array
        timeCapsules.removeAll { $0.capsuleId == capsuleId }
        
        // Remove the capsuleId from the user's timeCapsuleIds array
        users[userIndex].timeCapsuleIds.removeAll { $0 == capsuleId }
        
        // Update current user if needed
        if currentUser?.userId == userId {
            currentUser?.timeCapsuleIds.removeAll { $0 == capsuleId }
        }
        
        return true
    }
    
    // MARK: - Subtask Management
    
    func getSubtasks(for capsuleId: UUID) -> [Subtask] {
        if let capsule = getTimeCapsule(by: capsuleId) {
            return subtasks.filter { subtask in
                capsule.subtaskIds.contains(subtask.subtaskId)
            }
        }
        return []
    }
    
    func getSubtask(by subtaskId: UUID) -> Subtask? {
        return subtasks.first { $0.subtaskId == subtaskId }
    }
    
    func addSubtask(_ subtask: Subtask, to capsuleId: UUID) -> Bool {
        guard let capsuleIndex = timeCapsules.firstIndex(where: { $0.capsuleId == capsuleId }) else {
            print("Error: Time Capsule not found with ID \(capsuleId).")
            return false
        }
        
        // Add subtask to the subtasks array
        subtasks.append(subtask)
        
        // Update the capsule's subtaskIds array
        timeCapsules[capsuleIndex].subtaskIds.append(subtask.subtaskId)
        
        // Update the completion percentage
        let capsuleSubtasks = getSubtasks(for: capsuleId)
        timeCapsules[capsuleIndex].updateCompletionPercentage(subtasks: capsuleSubtasks)
        
        return true
    }
    
    func updateSubtask(_ subtask: Subtask, in capsuleId: UUID) {
        if let subtaskIndex = subtasks.firstIndex(where: { $0.subtaskId == subtask.subtaskId }) {
            subtasks[subtaskIndex] = subtask
            
            // Update the completion percentage of the associated capsule
            if let capsuleIndex = timeCapsules.firstIndex(where: { $0.capsuleId == capsuleId }) {
                let capsuleSubtasks = getSubtasks(for: capsuleId)
                timeCapsules[capsuleIndex].updateCompletionPercentage(subtasks: capsuleSubtasks)
            }
        }
    }
    
    func deleteSubtask(with subtaskId: UUID, from capsuleId: UUID) -> Bool {
        guard let capsuleIndex = timeCapsules.firstIndex(where: { $0.capsuleId == capsuleId }) else {
            print("Error: Time Capsule not found with ID \(capsuleId).")
            return false
        }
        
        // Remove the subtask from the subtasks array
        subtasks.removeAll { $0.subtaskId == subtaskId }
        
        // Remove the subtaskId from the capsule's subtaskIds array
        timeCapsules[capsuleIndex].subtaskIds.removeAll { $0 == subtaskId }
        
        // Update the completion percentage
        let capsuleSubtasks = getSubtasks(for: capsuleId)
        timeCapsules[capsuleIndex].updateCompletionPercentage(subtasks: capsuleSubtasks)
        
        return true
    }
    
    // MARK: - Award Management
    
    func getAllAwards() -> [Award] {
        return awards
    }
    
    func getAward(by awardId: UUID) -> Award? {
        return awards.first { $0.awardId == awardId }
    }
    
    func getUserAwards(for userId: UUID) -> [Award] {
        if let user = getUser(by: userId) {
            return user.awardsEarned.compactMap { earned in
                getAward(by: earned.awardId)
            }
        }
        return []
    }
    
    func awardUser(userId: UUID, awardId: UUID) -> Bool {
        guard let userIndex = users.firstIndex(where: { $0.userId == userId }) else {
            print("Error: User not found with ID \(userId).")
            return false
        }
        
        guard getAward(by: awardId) != nil else {
            print("Error: Award not found with ID \(awardId).")
            return false
        }
        
        // Create a new AwardsEarned instance
        let newAward = AwardsEarned(awardId: awardId, dateEarned: Date())
        
        // Add it to the user's awardsEarned array
        users[userIndex].awardsEarned.append(newAward)
        
        // Update current user if needed
        if currentUser?.userId == userId {
            currentUser?.awardsEarned.append(newAward)
        }
        
        return true
    }
    
    // MARK: - Helper Methods
    
    func getTodayDayIndex() -> Int {
        let today = Date()
        let calendar = Calendar.current
        // Get the weekday as a number (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        let weekday = calendar.component(.weekday, from: today)
        // Adjust to make Sunday = 0, Monday = 1, ..., Saturday = 6
        return weekday - 1
    }
    
    // MARK: - Private Methods
    
    private func setupSampleData() {
        // Sample awards
        let award1 = Award(awardName: "First Task Completed", description: "Completed your first task")
        let award2 = Award(awardName: "5-Day Streak", description: "Completed tasks for 5 consecutive days")
        let award3 = Award(awardName: "Time Master", description: "Completed 10 time capsules")
        
        awards = [award1, award2, award3]
        
        // Sample user
        let sampleSettings = Settings(
            usage: .personal,
            bedtime: "22:00",
            wakeUpTime: "06:00",
            notificationsEnabled: true
        )
        
        let sampleUser = User(
            name: "John Doe",
            email: "a@gmail.com",
            password: "123456",
            phone: "+1234567890",
            settings: sampleSettings
        )
        
        users.append(sampleUser)
        
        // Sample tasks
        let task1 = UserTask(
            taskName: "Morning Workout",
            description: "30-minute cardio session",
            startTime: "06:00",
            endTime: "06:30",
            date: Date(),
            priority: .high,
            alert: .fiveMinutes,
            category: .sports,
            isCompleted: true
        )
        
        let task2 = UserTask(
            taskName: "Team Meeting",
            description: "Weekly project status update",
            startTime: "10:00",
            endTime: "11:00",
            date: Date(),
            priority: .medium,
            alert: .tenMinutes,
            category: .meetings
        )
        let task3 = UserTask(
            taskName: "Project Work",
            description: "Weekly project status update",
            startTime: "10:00",
            endTime: "11:00",
            date: getMarch17Date(),
            priority: .medium,
            alert: .tenMinutes,
            category: .work
        )
        
        // Add tasks to the sample user
        _ = addTask(task1, for: sampleUser.userId)
        _ = addTask(task2, for: sampleUser.userId)
        _ = addTask(task3, for: sampleUser.userId)
        
        // Sample time capsule
        let capsule = TimeCapsule(
            capsuleName: "Learn Swift",
            deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
            priority: .medium,
            description: "Master Swift programming language basics",
            category: .study
        )
        
        _ = addTimeCapsule(capsule, for: sampleUser.userId)
        
        // Sample subtasks for the time capsule
        let subtask1 = Subtask(subtaskName: "Learn variables and constants")
        let subtask2 = Subtask(subtaskName: "Learn data types")
        let subtask3 = Subtask(subtaskName: "Learn control flow")
        
        _ = addSubtask(subtask1, to: capsule.capsuleId)
        _ = addSubtask(subtask2, to: capsule.capsuleId)
        _ = addSubtask(subtask3, to: capsule.capsuleId)
        
        // Award the user
        _ = awardUser(userId: sampleUser.userId, awardId: award1.awardId)
    }
}

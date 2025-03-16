import SwiftUI
import Foundation

struct HomeView: View {
    @State private var selectedDate = Date()
    @State var loggedUser: User?
    // Sample tasks (replace with actual data source)
    let taskModel = TaskDataModel.shared
    
    @State var tasks: [UserTask] = [
        UserTask(taskName: "Go Gym and do some exercises", description: "Workout session", startTime: "5:00PM", endTime: "6:30AM", date: Date(), priority: .high, alert: .oneHour, category: .sports, isCompleted: false),
        UserTask(taskName: "I want to study OOPs in C++", description: "Study Session", startTime: "6:00PM", endTime: "7:30PM", date: Date(), priority: .medium, alert: .oneHour, category: .study),
        UserTask(taskName: "Attend a meeting", description: "Work discussion", startTime: "10:00AM", endTime: "11:30AM", date: getMarch17Date(), priority: .high, alert: .oneHour, category: .work)
    ]
    
    var body: some View {
        ScrollView {
            // Header Section
            headerView
            
            // Weekly Dates Picker
            weekView
            
            // Task List
            taskList
            
            Spacer()
        }
        .padding()
        .onAppear {
            guard let x = loggedUser else { return }
            tasks = taskModel.getAllTasks(for: x.userId)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome, \(loggedUser?.name ?? "Dhruv")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(selectedDate.fullFormattedString())
                }
                Spacer()
                CircularProgressView(percentage: progressPercentage)
                    .frame(width: 70, height: 70)
            }
            .padding(5)
        }
        .padding(.horizontal)
    }
    
    private var progressPercentage: Int {
        let todayTasks = tasks.filter { $0.date.isSameDay(as: selectedDate) } // Filter today's tasks
        let completedTasks = todayTasks.filter { $0.isCompleted }.count // Count completed tasks
        let totalTasks = todayTasks.count
        
        return totalTasks > 0 ? Int((Double(completedTasks) / Double(totalTasks)) * 100) : 0
    }
    
    // MARK: - Week View
    private var weekView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Date().fullWeekDates(), id: \.self) { date in
                    VStack {
                        Text(date.formattedString(format: "d"))
                            .font(.headline)
                            .foregroundColor(selectedDate.isSameDay(as: date) ? .white : .black)
                        
                        Text(date.formattedString(format: "E"))
                            .font(.subheadline)
                            .foregroundColor(selectedDate.isSameDay(as: date) ? .white : .gray)
                    }
                    .frame(width: 50, height: 70)
                    .background(selectedDate.isSameDay(as: date) ? Color.purple : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding(.top,20)
        }
    }
    
    // MARK: - Task List
    private var taskList: some View {
        VStack(alignment: .center) {
            Text("My Tasks")
                .font(.headline)
                .padding(.vertical)
            ForEach(tasks.filter { $0.date.isSameDay(as: selectedDate) }) { task in
                TaskRow(task: task).padding(.vertical,5)
            }
        }
    }
}

// MARK: - Task Row
struct TaskRow: View {
    let task: UserTask
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: task.category.taskImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40) // Bigger icon
                .foregroundColor(.white)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.category.rawValue.capitalized) // Category Name
                    .font(.subheadline)
                
                Text(task.taskName) // Task Name
                    .font(.headline)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text("\(task.startTime) - \(task.endTime)") // Time
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            Text(">")
        }
        .padding()
        .background(
            Color(task.category.customCategory.categoryColor)
                .cornerRadius(10)
                .opacity(1.0) // Keep full opacity
        )
        .overlay(
            task.isCompleted ?
            Color.white.opacity(0.5) : Color.clear // Add an overlay for completed tasks
        )

    }
}



// MARK: - Circular Progress View
struct CircularProgressView: View {
    let percentage: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
                .foregroundColor(Color.purple)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage) / 100)
                .stroke(Color.purple, lineWidth: 8)
                .rotationEffect(.degrees(-90))
            
            Text("\(percentage)%")
                .font(.headline)
                .foregroundColor(.purple)
        }
        .frame(width: 80, height: 80)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}

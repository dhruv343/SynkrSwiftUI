import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()
    @State var loggedUser: User?
    // Sample tasks (replace with actual data source)
    let tasks: [UserTask] = [
        UserTask(taskName: "Go Gym and do some exercises", description: "Workout session", startTime: "5:00PM", endTime: "6:30AM", date: Date(), priority: .high, alert: .oneHour, category: .sports, isCompleted: true),
        UserTask(taskName: "I want to study OOPs in C++", description: "Study Session", startTime: "6:00PM", endTime: "7:30PM", date: Date(), priority: .medium, alert: .oneHour, category: .study),
        UserTask(taskName: "Attend a meeting", description: "Work discussion", startTime: "10:00AM", endTime: "11:30AM", date: Date(), priority: .high, alert: .oneHour, category: .work)
    ]
    
    var body: some View {
        VStack {
            // Header Section
            headerView
            
            // Weekly Dates Picker
            weekView
            
            // Task List
            taskList
            
            Spacer()
        }
        .padding()
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
                CircularProgressView(percentage: 80)
                    .frame(width: 70, height: 70)
            }
            .padding(5)
        }
        .padding(.horizontal)
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
            .padding(.top)
        }
    }
    
    // MARK: - Task List
    private var taskList: some View {
        VStack(alignment: .leading) {
            Text("My Tasks")
                .font(.headline)
                .padding(.vertical)
            
            ForEach(tasks.filter { $0.date.isSameDay(as: selectedDate) }) { task in
                TaskRow(task: task)
            }
        }
    }
}

// MARK: - Task Row
struct TaskRow: View {
    let task: UserTask
    
    var body: some View {
        HStack {
            Image(systemName: task.category.taskImage)
                .foregroundColor(.blue)
                .padding()
            
            VStack(alignment: .leading) {
                Text(task.taskName)
                    .font(.headline)
                
                Text("\(task.startTime) - \(task.endTime)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        .padding(.horizontal)
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

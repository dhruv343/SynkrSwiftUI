import SwiftUI

struct CustomTabBar: View {
    @State private var selectedTab = 0
    var loggedUser: User?  // User is now passed

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView(loggedUser: loggedUser)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)

                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(1)

                AwardsView()
                    .tabItem {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Awards")
                    }
                    .tag(2)

                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(3)
            }

            // Floating Add Button
            VStack {
                Spacer()
                AddButton()
            }
        }
    }
}

// MARK: - Floating Add Button
struct AddButton: View {
    var body: some View {
        Button(action: {
            print("Add Task Button Tapped")
        }) {
            ZStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 65, height: 65)
                    .shadow(radius: 5)

                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
            }
        }
        .offset(y: -30) // Move button above the tab bar
    }
}

// MARK: - Placeholder Views for Tabs

struct CalendarView: View {
    var body: some View {
        Text("Calendar Screen").font(.largeTitle)
    }
}

struct AwardsView: View {
    var body: some View {
        Text("Awards Screen").font(.largeTitle)
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Screen").font(.largeTitle)
    }
}

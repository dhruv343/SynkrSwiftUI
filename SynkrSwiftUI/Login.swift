import SwiftUI

struct AuthenticationView: View {
    @State private var showLogin = true
    
    var body: some View {
        if showLogin {
            LoginView(toggleView: { showLogin = false })
        } else {
            SignupView(toggleView: { showLogin = true })
        }
    }
}

struct LoginView: View {
    var toggleView: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil
    @State public var loggedUser: User? = nil
    
    var body: some View {
        VStack(spacing: 15) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            
            Text("Log in to your account")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, -10)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: handleLogin) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Text("or continue with")
                .foregroundColor(.gray)
            
            Button(action: {
                print("Continue with Google")
            }) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.red)
                    Text("Continue with Google")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Text("Don't have an account?")
                Button("Sign up") {
                    toggleView()
                }
                .foregroundColor(.blue)
                .fontWeight(.bold)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" // Standard email regex
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6 // Ensure password is at least 6 characters long
    }
    
    func handleLogin() {
        if !validateEmail(email) {
            errorMessage = "Invalid email format."
            return
        }
        if !validatePassword(password) {
            errorMessage = "Password must be at least 6 characters."
            return
        }
        
        let taskDataModel = TaskDataModel.shared // Assuming singleton pattern
        if let x = taskDataModel.validateUser(email: email, password: password) {
            print("Login successful!")
            loggedUser = x
            print(x)
            print(x.taskIds.count)
            print(x.awardsEarned.count)
            if let ab = taskDataModel.getTimeCapsule(by: x.timeCapsuleIds[0]){
                print(ab)
            }
            errorMessage = nil
            // Navigate to home screen (implement navigation logic here)
        } else {
            errorMessage = "Invalid credentials. Please try again."
        }
    }
}


// Preview
#Preview {
    AuthenticationView()
}

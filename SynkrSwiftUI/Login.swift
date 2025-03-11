import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 15) { // Reduced spacing for better alignment
            // App Logo
            Image("Logo") // Replace with your asset name
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250) // Increased size to match SignupView
            
            // Short text under the logo
            Text("Log in to your account")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, -10) // Align better under logo

            // Email Field
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)

            // Password Field
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            // Login Button
            Button(action: {
                print("Login Button Tapped")
            }) {
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

            // Continue with Google Button
            Button(action: {
                print("Continue with Google")
            }) {
                HStack {
                    Image(systemName: "globe") // Replace with Google logo asset if available
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
            
            // Signup Link
            HStack {
                Text("Don't have an account?")
                NavigationLink(destination: SignupView()) {
                    Text("Sign up")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

// Preview
#Preview {
    NavigationView {
        LoginView()
    }
}

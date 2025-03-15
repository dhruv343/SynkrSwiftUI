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
    
    var body: some View {
        VStack(spacing: 15) {
            // App Logo
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            
            // Short text under the logo
            Text("Log in to your account")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, -10)

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
                print(email)
                print(password)
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
            
            // Signup Link
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
}

// Preview
#Preview {
    AuthenticationView()
}

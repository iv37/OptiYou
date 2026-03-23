import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var mode: AuthMode = .login
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 12)

            VStack(alignment: .leading, spacing: 18) {
                ChipView(text: "Secure sign in", tint: AppTheme.primary)
                Text("Create an account or log in before starting your first evaluation.")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.foreground)
                Text("The dashboard, recommendations, and progress history are protected until a secure session exists.")
                    .font(.headline)
                    .foregroundStyle(AppTheme.muted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                Picker("Mode", selection: $mode) {
                    Text("Log in").tag(AuthMode.login)
                    Text("Sign up").tag(AuthMode.signup)
                }
                .pickerStyle(.segmented)
                .colorScheme(.dark)

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .luxuryInput()

                    SecureField("Password", text: $password)
                        .luxuryInput()
                }

                if let errorMessage = appModel.authErrorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.danger)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(appModel.isAuthenticating ? "Working..." : (mode == .login ? "Log in" : "Create account")) {
                    Task {
                        await appModel.authenticate(mode: mode, email: email, password: password)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(appModel.isAuthenticating || email.isEmpty || password.isEmpty)

                Button("Dev bypass") {
                    appModel.enableDevBypass()
                }
                .buttonStyle(SecondaryButtonStyle())

                Text("Current user fetch example will appear in Settings after login.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Use the dev bypass to jump into onboarding without real auth so we can keep building the product flow.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .glassCard()

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 28)
        .task {
            await appModel.restoreSessionIfNeeded()
        }
    }
}

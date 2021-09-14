//
//  LoginPage.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI
import AuthenticationServices
import Combine
import os

struct LoginPage: View {
    private var logger = Logger(subsystem: bundleId, category: "LandingPage")

    @EnvironmentObject var authManager: AuthManager
    @Environment(\.colorScheme) var colorScheme
    @State private var buttonsDisabled: Bool = false
    @State private var presentAlert: Bool = false
    @State private var failureReason: String = ""
    @StateObject private var client = NetworkClient<AuthRequest, Empty>()

    var body: some View {
        VStack {
            Image(Asset.Images.tendiesImage.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
                .shadow(radius: 4)

            Text(L10n.App.name)
                .font(.largeTitle)
                .fontWeight(.black)

            Spacer().frame(height: 32)

            signInButton

            Spacer().frame(height: 32)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .opacity(buttonsDisabled ? 1 : 0)
        }
        .padding()
        .alert(isPresented: $presentAlert) {
            let title = Text(
                "Failed to Sign in.",
                comment: "Sign in Alert Failure Title"
            )

            let message = Text(
                "\(failureReason)",
                comment: "Sign up with apple failure alert message"
            )

            #if DEBUG
            return Alert(
                title: title,
                message: message,
                primaryButton: .destructive(
                    Text(L10n.LandingPage.Button.skip),
                    action: {
                        authManager.authToken = "skipSignUp"
                    }
                ),
                secondaryButton: .cancel()
            )
            #else
            return Alert(
                title: title,
                message: message,
                dismissButton: .cancel()
            )
            #endif
        }
        .onReceive(client.$urlResponse.compactMap({$0})) { urlResponse in
            if urlResponse.isSuccess {
                authManager.authToken = authManager.appleUserId ?? ""
            } else if let error = client.error {
                failureReason = error.localizedDescription
            }
        }
    }

    @ViewBuilder private var signInButton: some View {
        #if DEBUG

        Button {
            let uuid = UUID()
            authManager.appleUserId = uuid.uuidString
            client.request = ApiRequest(endpoint: .auth, requestBody: AuthRequest(uuid: uuid.uuidString))
            authManager.fetchAuthToken(with: client)
        } label: {
            Text(L10n.LandingPage.Button.skip)
        }
        .buttonStyle(LargeButtonStyle(color: .accentColor))
        .frame(maxWidth: .infinity, minHeight: 30, idealHeight: 38, maxHeight: 48)
        .padding(.horizontal)

        #else

        SignInWithAppleButton(
            onRequest: { _ in
                buttonsDisabled = true
            },
            onCompletion: { result in
                switch result {
                case .success(let authenticationResults):
                    guard let credentials =
                            authenticationResults.credential as? ASAuthorizationAppleIDCredential else {
                        return
                    }

                    authManager.appleUserId = credentials.user

                    client.request = ApiRequest(endpoint: .auth, requestBody: AuthRequest(uuid: credentials.user))

                    authManager.fetchAuthToken(with: client)
                case .failure(let error):
                    guard let error = error as? ASAuthorizationError else {
                        return
                    }

                    switch error.code {
                    case .canceled:
                        return
                    default:
                        logger.error(
                            """
                            Sign in with Apple Failed.
                            Code: \(error.errorCode)
                            """
                        )
                        failureReason = "\(String(describing: error))"
                    }
                }

                buttonsDisabled = false
            }
        )
        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
        .frame(height: 38)
        .frame(maxWidth: .infinity)
        .disabled(buttonsDisabled)

        #endif
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
            .environmentObject(MockAuthManager())
    }
}

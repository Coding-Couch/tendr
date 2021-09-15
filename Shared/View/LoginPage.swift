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

private typealias AppleCredential = ASAuthorizationAppleIDCredential

struct LoginPage: View {
    private var logger = Logger(subsystem: bundleId, category: "LandingPage")

    @EnvironmentObject var authManager: AuthManager
    @Environment(\.colorScheme) var colorScheme
    @State private var alertContent: AlertContent?
    @State private var failureReason: String = ""
    @State private var signInWithAppleLoading: Bool = false

    var isLoading: Bool {
        authManager.isLoading || signInWithAppleLoading
    }

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

            signInWithAppleButton
            signInButton

            Spacer().frame(height: 32)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .opacity(authManager.isLoading ? 1 : 0)
        }
        .padding()
        #if DEBUG
        .alert(item: $alertContent) { alertContent in
            Alert(
                title: Text(alertContent.title),
                message: Text(alertContent.message ?? ""),
                dismissButton: .cancel()
            )
        }
        #else
        .alert(item: $alertContent) { alertContent in
            Alert(
                title: Text(alertContent.title),
                message: Text(alertContent.message ?? ""),
                primaryButton: .destructive(
                    Text(L10n.LandingPage.Button.skip),
                    action: {
                        authManager.authToken = "skipSignUp"
                    }
                ),
                secondaryButton: .cancel()
            )
        }
        #endif
    }

    @ViewBuilder private var signInButton: some View {
        Button {
            Task {
                do {
                    try await authManager.fetchAuthToken(with: UUID().uuidString)
                } catch {
                    alertContent = AlertContent(
                        title: L10n.LandingPage.Error.Tendr.title,
                        message: L10n.LandingPage.Error.Tendr.message(error.localizedDescription)
                    )
                }
            }
        } label: {
            Text(L10n.LandingPage.Button.skip)
        }
        .buttonStyle(LargeButtonStyle(color: .accentColor))
        .frame(maxWidth: .infinity, minHeight: 30, idealHeight: 38, maxHeight: 48)
        .padding(.horizontal)
    }

    @ViewBuilder private var signInWithAppleButton: some View {
        SignInWithAppleButton { request in
            logger.info("Apple User: \(request.user ?? "nil")")
            signInWithAppleLoading = true
        } onCompletion: { result in
            switch result {
            case .success(let authenticationResults):
                guard let credentials = authenticationResults.credential as? AppleCredential else {
                    return
                }

                Task {
                    do {
                        try await authManager.fetchAuthToken(with: credentials.user)
                    } catch {
                        alertContent = AlertContent(
                            title: L10n.LandingPage.Error.Tendr.title,
                            message: L10n.LandingPage.Error.Tendr.message(error.localizedDescription)
                        )
                    }

                    signInWithAppleLoading = false
                }
            case .failure(let error):
                guard let appleError = error as? ASAuthorizationError else {
                    logger.error("An unknown error occured during Sign In With Apple: \(error.localizedDescription)")
                    let nsError = error as NSError
                    alertContent = AlertContent(
                        title: L10n.LandingPage.Error.Apple.title,
                        message: L10n.LandingPage.Error.Apple.message(nsError.code, nsError.localizedDescription)
                    )
                    return
                }

                switch appleError.code {
                case .canceled:
                    return
                default:
                    logger.error("""
                        Sign in with Apple Failed.
                        Code: \(appleError.errorCode)
                        Description: \(appleError.localizedDescription)
                        """)

                    alertContent = AlertContent(
                        title: L10n.LandingPage.Error.Apple.title,
                        message: L10n.LandingPage.Error.Apple.message(
                            appleError.code,
                            appleError.localizedDescription
                        )
                    )
                }

                signInWithAppleLoading = false
            }
        }
        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
        .frame(height: 38)
        .frame(maxWidth: .infinity)
        .disabled(authManager.isLoading)
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
            .environmentObject(MockAuthManager())
    }
}

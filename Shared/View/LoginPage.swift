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
				Image("tendies-image")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: 150)
					.clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
					.shadow(radius: 4)
				
				Text("Tendr")
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
				Alert(
					title: Text(
						"Failed to Sign in.",
						comment: "Sign in Alert Failure Title"
					),
					message: Text(
						"\(failureReason)",
						comment: "Sign up with apple failure alert message"
					),
					primaryButton: .destructive(
						Text("Skip Signup"),
						action: {
							authManager.authToken = "skipSignUp"
						}
					),
					secondaryButton: .cancel()
				)
			}
			.onReceive(client.$urlResponse.compactMap({$0})) { urlResponse in
				if urlResponse.isSuccess {
					authManager.authToken = "appleSignUpSuccess"
				} else if let error = client.error {
					failureReason = error.localizedDescription
				}
			}
    }
	
	@ViewBuilder private var signInButton: some View {
		#if DEBUG
		
		Button {
			authManager.fetchAuthToken(with: client)
		} label: {
			Text("Skip Signup Process")
		}
		.buttonStyle(LargeButtonStyle(color: .accentColor))
		.frame(maxWidth: .infinity, minHeight: 30, idealHeight: 38, maxHeight: 48)
		.padding(.horizontal)
		
		#else
		
		SignInWithAppleButton(
			onRequest: { request in
				buttonsDisabled = true
			},
			onCompletion: { result in
				switch result {
				case .success (let authenticationResults):
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

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
			.environmentObject(MockAuthManager())
    }
}

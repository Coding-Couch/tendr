//
//  LandingPage.swift
//  Tendr (iOS)
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI
import AuthenticationServices

struct LandingPage: View {
	@EnvironmentObject var authManager: AuthManager
	@Environment(\.colorScheme) var colorScheme
	@State var buttonsDisabled: Bool = false
	
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
				
				buttonStack
				
				Spacer().frame(height: 32)
				
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.opacity(buttonsDisabled ? 1 : 0)
			}
			.padding()
    }
	
	@ViewBuilder private var buttonStack: some View {
		VStack(alignment: .center) {
			SignInWithAppleButton(
				onRequest: { request in
					buttonsDisabled = true
					request.requestedScopes = []
				},
				onCompletion: { result in
					switch result {
					case .success (let authenticationResults):
						print("Authorization successful!: \(authenticationResults)")
						
						guard let credentials =
								authenticationResults.credential as? ASAuthorizationAppleIDCredential else {
							return
						}
						
					case .failure(let error):
						print("Authorization failed: " + error.localizedDescription)
					}
					
					buttonsDisabled = false
				}
			)
			.signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
			.frame(width: 343, height: 48)
			.disabled(buttonsDisabled)
			
			Button {
				let uuid = UUID()
				authManager.fetchAuthToken(with: uuid)
			} label: {
				Text("Sign Up")
			}
			.buttonStyle(LargeButtonStyle(color: .blue))
			.frame(width: 343, height: 48)
			.disabled(buttonsDisabled)
			
			
			
			HStack {
				Text("Already have an account?")
				
				Button {
					
				} label: {
					Text("Log In")
				}
				.disabled(buttonsDisabled)
			}
		}
	}
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
			.environmentObject(MockAuthManager())
    }
}

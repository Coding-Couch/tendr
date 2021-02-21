//
//  LandingPage.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-19.
//

import SwiftUI
import AuthenticationServices

struct LandingPage: View {
	@EnvironmentObject var authManager: AuthManager
	@Environment(\.colorScheme) var colorScheme
	@State private var isLoading = false
	
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
				
				SignInWithAppleButton(
					onRequest: { request in
						isLoading = true
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
							
							authManager.appleUserId = credentials.user
							authManager.fetchAuthToken(with: credentials.user)
						case .failure(let error):
							print("Authorization failed: " + error.localizedDescription)
						}
						
						isLoading = false
					}
				)
				.signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
				.frame(height: 38)
				.frame(maxWidth: .infinity)
				.disabled(isLoading)
				
				Spacer().frame(height: 32)
				
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.opacity(isLoading ? 1 : 0)
			}
			.frame(minWidth: 300, maxWidth: 400, minHeight: 400, maxHeight: .infinity, alignment: .center)
			.padding()
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
			.environmentObject(MockAuthManager())
    }
}

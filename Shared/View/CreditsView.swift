//
//  CreditsView.swift
//  Shared
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
		VStack {
			Image("tendies-image")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 150)
				.clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
				.shadow(radius: 4)
			
			Text(
				"Tendr was created by team Coding Couch for 2021 SwiftUIJam",
				 comment: "Created by description"
			)
			.font(.title2)
			.fontWeight(.bold)
			.multilineTextAlignment(.center)
			
			Spacer().frame(height: .margin * 2)
			
			VStack(alignment: .leading) {
				Text("Team Members")
					.font(.title3)
					.bold()
				
				Spacer().frame(height: .smallMargin)
				
				Text("Brent Mifsud - Team Lead, iOS Developer")
				Text("Vince Romani - iOS Developer")
				Text("Ahmed Al-Hulaibi - Back End, Golang Developer")
				Text("Sahand Nayebaziz - Floating Designer")
			}
			.multilineTextAlignment(.leading)
			
			Spacer()
		}
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}

//
//  CreditsView.swift
//  Tendr
//
//  Created by Brent Mifsud on 2021-02-20.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
		VStack {
			Text("Credits", comment: "Credits Title")
				.font(.largeTitle)
				.fontWeight(.black)
			
			Spacer().frame(height: 34)
			
			Text("Created by Coding Couch for 2021 SwiftUIJam", comment: "Created by Label")
				.font(.title2)
				.fontWeight(.bold)
			
			Spacer().frame(height: .margin)
			
			VStack {
				Text("Brent Mifsud - Team Lead, iOS Developer")
				Text("Vince Romani - iOS Developer")
				Text("Ahmed Al-Hulaibi - Back End, Golang Developer")
				Text("Sahand Nayebaziz - Floating Designer")
			}
			
			Spacer()
		}
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}

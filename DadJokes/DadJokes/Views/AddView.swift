//
//  AddView.swift
//  DadJokes
//
//  Created by Owen Henley on 24/09/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Properties
    
    @State private var setup = ""
    @State private var punchline = ""
    @State private var rating = "Silence"
    let ratings = ["Sob", "Sigh", "Silence", "Smirk"]
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Setup", text: $setup)
                    TextField("Punchline", text: $punchline)
                    
                    Picker("Rating", selection: $rating) {
                        ForEach(ratings, id: \.self) { rating in
                            Text(rating)
                        }
                    }
                }
                Button("Add Joke") {
                    let newJoke = Joke(context: self.moc)
                    newJoke.setup = self.setup
                    newJoke.punchline = self.punchline
                    newJoke.rating = self.rating
                    
                    do {
                        try self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("\(error.localizedDescription)")
                    }
                }
            }
        }.navigationBarTitle("New Joke")
    }
}


// MARK: - Preview

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

//
//  ContentView.swift
//  DadJokes
//
//  Created by Owen Henley on 23/09/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Joke.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Joke.setup, ascending: true)
    ]) var jokes: FetchedResults<Joke>
    @State private var showingAddJoke = false
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            List {
                ForEach(jokes, id: \.setup) { joke in
                    NavigationLink(destination: Text(joke.punchline)) {
                        HStack {
                            EmojiView(for: joke.rating)
                            Text(joke.setup)
                        }
                    }
                }
                .onDelete(perform: removeJokes(at:))
            }
            .navigationBarTitle("Dad Jokes")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add") {
                self.showingAddJoke.toggle()
            })
            .sheet(isPresented: $showingAddJoke) {
                AddView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func removeJokes(at offsets: IndexSet) {
        for index in offsets {
            let joke = jokes[index]
            moc.delete(joke)
        }
        
        // do-try-catch
        try? moc.save()
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

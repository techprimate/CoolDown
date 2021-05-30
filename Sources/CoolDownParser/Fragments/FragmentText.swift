class FragmentText: Fragment {
    var text: [Character]

    init(character: Character) {
        self.text = [character]
    }

    init(characters: [Character]) {
        self.text = characters
    }
}

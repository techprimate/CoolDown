class FragmentLexer: IteratorProtocol {

    let content: Substring
    var offset: Int = 0

    init(content: Substring) {
        self.content = content
    }

    var currentCharacter: Character? {
        guard offset >= 0 && offset < content.count else {
            return nil
        }
        return content[content.index(content.startIndex, offsetBy: offset)]
    }

    func peakPrevious(count: Int = 1) -> Character? {
        offset -= count
        let character = currentCharacter
        offset += count
        return character
    }

    func next() -> Character? {
        let character = self.currentCharacter
        offset += 1
        return character
    }

    func peakNext() -> Character? {
        let character = next()
        rewindCharacter()
        return character
    }

    func rewindCharacter() {
        assert(offset > 0, "Do not rewind below zero!")
        offset -= 1
    }

    func rewindCharacters(count: Int) {
        offset -= count
    }
}

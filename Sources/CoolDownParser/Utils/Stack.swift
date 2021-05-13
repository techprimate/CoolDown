struct Stack<Element> {

    var elements: [Element]

    // MARK: Initializers

    init() {
        self.elements = []
    }

    init(elements: [Element]) {
        self.elements = elements
    }

    // MARK: - Push & Pop

    /// Adds a new element at the top of the stack.
    ///
    /// Use this method to push a single element to the end of a mutable stack.
    ///
    ///     var numbers: Stack = [1, 2, 3, 4, 5]
    ///     numbers.push(100)
    ///     print(numbers)
    ///     // Prints "[1, 2, 3, 4, 5, 100]"
    ///
    /// For more details, see `Array.append`
    ///
    /// - Parameter element: The element to append to the array.
    mutating func push(_ element: Element) {
        elements.append(element)
    }

    /// Removes and returns the last element of the stack.
    ///
    /// Calling this method may invalidate all saved indices of this
    /// stack. Do not rely on a previously stored index value after
    /// altering a collection with any operation that can change its length.
    ///
    /// For more details, see `Array.popLast`
    ///
    /// - Returns: The top most element of the stack if the collection is not
    /// empty; otherwise, `nil`.
    mutating func pop() -> Element? {
        elements.popLast()
    }

    /// The last element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers: Stack = [10, 20, 30, 40, 50]
    ///     if let lastNumber = numbers.last {
    ///         print(lastNumber)
    ///     }
    ///     // Prints "50"
    ///
    /// For more details, see `Array.top`
    var top: Element? {
        elements.last
    }
}

extension Stack: Collection {

    // MARK: - Collection

    typealias Index = Int

    func index(after i: Int) -> Int {
        elements.index(after: i)
    }

    var startIndex: Int {
        elements.startIndex
    }

    var endIndex: Int {
        elements.endIndex
    }

    subscript(bounds: Range<Int>) -> ArraySlice<Stack<Element>> {
        ArraySlice(arrayLiteral: Stack(Array(elements[bounds])))
    }

    subscript(position: Int) -> Element? {
        elements[position]
    }
}

// MARK: - RangeReplaceableCollection

extension Stack: RangeReplaceableCollection {

    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, Self.Element == C.Element {
        var optionalElements: [Element?] = elements.map { $0 }
        optionalElements.replaceSubrange(subrange, with: newElements)
        self.elements = optionalElements.compactMap { $0 }
    }
}

extension Stack: ExpressibleByArrayLiteral {

    typealias ArrayLiteralElement = Element

    init(arrayLiteral elements: Element...) {
        self.elements = elements
    }
}

/// Sequence which work as a "Last In, First Out" (LIFO) data structure.
///
/// In a stack, each item is placed on top of the previous item, one at a time.
/// Items can be removed from either the top of the stack (FILO) or from the bottom of the stack FIFO.
struct Stack<Element> {

    var elements: [Element]

    // MARK: Initializers

    /// Creates a stack with no elements inside
    init() {
        self.elements = []
    }

    /// Creates a stack with the given elements
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

    /// Indicies are
    typealias Index = Int

    /// The position of the first element in a nonempty stack.
    var startIndex: Int {
        0
    }

    /// The stack's "past the end" position---that is, the position one greater
    /// than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of an array, use the
    /// half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    ///     let numbers: Stack<Int> = [10, 20, 30, 40, 50]
    ///     if let i = numbers.firstIndex(of: 30) {
    ///         print(numbers[i ..< numbers.endIndex])
    ///     }
    ///     // Prints "[30, 40, 50]"
    ///
    /// If the stack is empty, `endIndex` is equal to `startIndex`.
    var endIndex: Int {
        elements.endIndex
    }

    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than `endIndex`.
    /// - Returns: The index immediately after `i`.
    func index(after index: Int) -> Int {
        elements.index(after: index)
    }

    /// See `Array.subscript(bounds:)`
    subscript(bounds: Range<Int>) -> ArraySlice<Stack<Element>> {
        ArraySlice([Stack(Array(elements[bounds]))])
    }

    /// See `Array.subscript(position:)`
    subscript(position: Int) -> Element? {
        elements[position]
    }
}

// MARK: - RangeReplaceableCollection

extension Stack: RangeReplaceableCollection {

    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, Self.Element == C.Element {
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

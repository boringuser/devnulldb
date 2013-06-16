package com.boringuser.ces;

import haxe.FastList;

/**
 * Allows for buffering items, such as events, to read later. Each added item is buffered, and calling mark() moves the
 * buffered items into a readable state. The set of readable items does not change until mark() is called again. In this
 * way, we can distinguish between capturing new data and processing previously-captured data. This mechanism also
 * allows multiple systems to read the buffered data.
 */
class Buffer<T>
{
    private var input : FastList<T>;
    private var output: FastList<T>;

    public function new ()
    {
        this.input = new FastList<T>();
        this.output = new FastList<T>();
    }

    /**
     * Add an item to the buffer. It won't be available for reading until after mark() is invoked.
     */
    public function add (item : T) : Void
    {
        this.input.add(item);
    }

    /**
     * After calling mark(), all previously added items can be iterated.
     */
    public function iterator () : Iterator<T>
    {
        return this.output.iterator();
    }

    /**
     * Allows all items added since mark() was last called (or since the instance was created) to be read. All items
     * added after mark() is called will be readable via iterator() once mark is called again.
     */
    public function mark () : Void
    {
        this.output = this.input;
        this.input = new FastList<T>();
    }
}
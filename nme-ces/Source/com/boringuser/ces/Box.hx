package com.boringuser.ces;

/**
 * An indexed container of items.
 */
class Box<T>
{
    private var availableIds : Array<Int>;
    private var items : Array<T>;

    public function new ()
    {
        this.availableIds = new Array<Int>();
        this.items = new Array<T>();
    }

    /**
     * Adds an item and returns its index.
     */
    public function add (item : T) : Int
    {
        if (this.availableIds.length > 0) {
            var index = availableIds.shift();
            this.items[index] = item;
            return index;
        }

        return this.items.push(item) - 1;
    }

    /**
     * Sets the item at the specified index. Throws if the index does not exist.
     */
    public function set (index : Int, item : T) : Void
    {
        if (index >= this.items.length) {
            throw(index + " is not a valid index");
        }

        this.items[index] = item;
    }
    
    /**
     * Removes an item, making its old index available for future additions. Returns true if there was an item at the
     * specified index and it was removed, false otherwise.
     */
    public function remove (index : Int) : Bool
    {
        if (index >= this.items.length || this.items[index] == null) {
            return false;
        }

        this.items[index] = null;
        this.availableIds.push(index);

        return true;
    }

    /**
     * Gets an item at the specified index or null if it does not exist.
     */
    public function get (index : Int) : T
    {
        if (index >= this.items.length) return null;
        return this.items[index];
    }

    /**
     * Returns true if there is an item at the specified index, false otherwise.
     */
    public function exists (index : Int) : Bool
    {
        return index < this.items.length && this.items[index] != null;
    }

    /**
     * Gets the index of the specified item, or -1 if it does not exist.
     */
    public function find (item : T) : Int
    {
        for (i in 0...items.length)
        {
            if (this.items[i] == item) return i;
        }

        return -1;
    }
}
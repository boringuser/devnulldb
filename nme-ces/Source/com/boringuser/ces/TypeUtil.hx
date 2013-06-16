package com.boringuser.ces;

/**
 * A utility class with static methods for getting type-related information about classes and instances.
 */
class TypeUtil
{
    /**
     * Given an object instance, returns its class.
     */
    public static function getClassForInstance<T> (instance :T) : Class<T>
    {
        return Type.getClass(instance);
    }

    /**
     * Given an object instance, returns its class name.
     */
    public static function getClassNameForInstance<T> (instance : T) : String
    {
        return Type.getClassName(getClassForInstance(instance));
    }

    /**
     * Given a class, returns its name.
     */
    public static function getClassNameForClass<T> (clazz : Class<T>) : String
    {
        return Type.getClassName(clazz);
    }
}
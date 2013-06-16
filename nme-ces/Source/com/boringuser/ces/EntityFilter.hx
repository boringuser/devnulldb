package com.boringuser.ces;

/**
 * Entity filters allow systems to specify the entities they are interested in.
 */
interface EntityFilter
{
    /**
     * Filters out an entity, returning true if the entity is one the filter wants to include, or false if the filter
     * excludes it.
     */
    function filter (entityName : String) : Bool;
}
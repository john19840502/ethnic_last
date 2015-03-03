/**
 * Basic functions for every website
 * Change events.js for site specific JS
 */

// Check if element exists
function elementExists(element) {
    if($(element).length) {
        return true;
    }
    return false;
}
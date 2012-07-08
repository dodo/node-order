# [Order](https://github.com/dodo/node-order)

Flow control to keep callbacks in order no matter which one finishs first and handle them as a list.

## install

    npm install order

## usage

```javascript
var Order = require('order');

list = new Order(function (idx) {
    // handle here ready elements
    idx.before;  // index of the previous element that is ready before idx.i
    idx.i;       // index of the element that got ready
    idx.after;   // index of the next element that is ready after idx.i
    this[idx.i]; // the ready element
});

list.push(function (done) {
    var element = {value:3}; // create new element
    setTimeout(function () { // fake async call
        element.value = 5;   // now set real value
        done();              // say, that this element is ready
    }, 23);
    return element;
});
```

When calling done the callback given to the constructor gets called.

## api

It it basically the exact same api like javascripts [`Array`](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/) has with the little exception, that it doesn't take direct values, but functions that return the value.
Also it is _not possible_ to specify an `Order` with a given size like `new Array(23)`.


[![Build Status](https://secure.travis-ci.org/dodo/node-order.png)](http://travis-ci.org/dodo/node-order)

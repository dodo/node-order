# [order](https://github.com/dodo/node-order)

handle callbacks in order no matter which one finish first and handle them as a list.

## install

    npm install order

## usage

```javascript
Order = require('order');

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



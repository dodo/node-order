
Order = require '../order'

module.exports =

    async: (æ) ->
        n = 0
        results = [
            {idx:1, before:-1, after:-1}
            {idx:2, before:+1, after:-1}
            {idx:3, before:+2, after:-1}
            {idx:0, before:-1, after:+1}
        ]
        list = new Order (e) ->
            æ.deepEqual e, results.shift()

        list.push ((done) -> setTimeout(done, 30);n++)
        list.push ((done) -> setTimeout(done, 10);n++)
        list.push ((done) -> setTimeout(done, 20);n++)

        list.insert 1, ((done) -> setTimeout(done, 4);n++)

        æ.equal list.length, 4
        æ.deepEqual list.slice(), [0, 3, 1, 2]
        æ.deepEqual list.done, [no, no, no, no]

        setTimeout ->
            æ.equal results.length, 0
            æ.deepEqual list.done, [yes, yes, yes, yes]
            æ.done()
        , 32


    sync: (æ) ->
        n = 0
        results = [
            {idx:0, before:-1, after:-1}
            {idx:1, before:+0, after:-1}
            {idx:2, before:+1, after:-1}
            {idx:1, before:+0, after:+2}
        ]
        list = new Order (e) ->
            æ.deepEqual e, results.shift()
        list.push (done) -> done();n++
        list.push (done) -> done();n++
        list.push (done) -> done();n++
        list.insert 1, (done) -> done();n++

        æ.equal list.length, 4
        æ.deepEqual list.slice(), [0, 3, 1, 2]
        æ.deepEqual list.done, [yes, yes, yes, yes]
        æ.equal results.length, 0
        æ.done()


    rm: (æ) ->
        n = 0
        results = [
            {idx:0, before:-1, after:-1}
            {idx:1, before:+0, after:-1}
            {idx:2, before:+1, after:-1}
            {idx:3, before:+2, after:-1}
        ]
        list = new Order (e) ->
            æ.deepEqual e, results.shift()
        list.push (done) -> done();n++
        list.push (done) -> done();n++
        list.push (done) -> done();n++
        list.push (done) -> done();n++

        list.remove(1)
        æ.deepEqual list.slice(), [0, 2, 3]
        æ.equal list.done.length, 3
        æ.equal list.keys.length, 3
        æ.equal list.length, 3

        list.pop()
        æ.deepEqual list.slice(), [0, 2]
        æ.equal list.done.length, 2
        æ.equal list.keys.length, 2
        æ.equal list.length, 2

        list.shift()
        æ.deepEqual list.slice(), [2]
        æ.equal list.done.length, 1
        æ.equal list.keys.length, 1
        æ.equal list.length, 1

        æ.equal results.length, 0
        æ.done()
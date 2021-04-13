Example that shows how to glue [reactive-banana](https://hackage.haskell.org/package/reactive-banana) and [qtah-qt5](https://hackage.haskell.org/package/qtah-qt5). This is a port (from wxWidgets to Qt5) of the [reactive-banana-wx's counter example](https://github.com/HeinrichApfelmus/reactive-banana/blob/master/reactive-banana-wx/src/Counter.hs).

Source code of [reactive-banana v1.2.1.0](https://github.com/HeinrichApfelmus/reactive-banana/tree/v1.2.1.0) has been copied into the repository, because `stack` couldn't pull it in due to [problems with versions of dependencies](https://github.com/mode89/reactive-banana-example-qt/commit/866b77691db0d51efb1e350d2c268ca41924bee4).

### Requirements

* [Haskell Stack](https://docs.haskellstack.org/en/stable/README/)
* Qt5 (tested on Qt 5.15, might not work on earlier versions)
* Tested on Linux. Might work on other platforms as well.

### Usage

Clone the repository, build and run with `stack`:
```
$ git clone https://github.com/mode89/reactive-banana-example-qt
$ cd reactive-banana-example-qt
$ stack build
$ stack run
```
Should get something like this:

![Screenshot](/screenshot.png?raw-true)

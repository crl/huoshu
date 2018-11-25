console.log = function(f){
    return function(v)
    {
        var str=JSON.stringify({c:"log",d:v});
        window.webkit.messageHandlers.ios.postMessage(str);
        f.call(console,v);
    }
}(console.log);
console.error = function(f){
    return function(v)
    {
        var str=JSON.stringify({c:"error",d:v});
        window.webkit.messageHandlers.ios.postMessage(str);
        f.call(console,v);
    }
}(console.error);

console.warn = function(f){
    return function(v)
    {
        var str=JSON.stringify({c:"warn",d:v});
        window.webkit.messageHandlers.ios.postMessage(str);
        f.call(console,v);
    }
}(console.warn);

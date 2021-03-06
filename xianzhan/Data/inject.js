console.log = function(f){
    return function()
    {
        var v=arguments;
        var str=JSON.stringify({c:"log",d:v});
        window.webkit.messageHandlers.ios.postMessage(str);
        f.apply(console,v);
    }
}(console.log);
console.error = function(f){
    return function()
    {
        var v=arguments;
        var str=JSON.stringify({c:"error",d:v});
        window.webkit.messageHandlers.ios.postMessage(str);
        f.apply(console,v);
    }
}(console.error);

console.warn = function(f){
    return function()
    {
        var v=arguments;
        var str=JSON.stringify({c:"warn",d:v});
        window.webkit.messageHandlers.ios.postMessage(str);
        f.apply(console,v);
    }
}(console.warn);


window.onerror = function (message, source, lineno, colno, error) {
    var v=arguments;
    var str=JSON.stringify({c:"windowError",d:v});
    window.webkit.messageHandlers.ios.postMessage(str);
}

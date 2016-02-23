var console = {
 	log:function(string) {
 		var dicParam = {paramsString:string};
 		var params = {className:'Console',classSelector:'log:',classParams:dicParam};
 		window.webkit.messageHandlers.jsCall.postMessage(params);
 	},
    show:function(message) {
        var dicParam = {'message':message};
        var params = {className:'Console',classSelector:'show:',classParams:dicParam};
        window.webkit.messageHandlers.jsCall.postMessage(params);
    }
 };
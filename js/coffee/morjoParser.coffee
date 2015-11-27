sendData = (data) ->
	XHR = new XMLHttpRequest()
	FD = new FormData()

	for name of data
		FD.append name, data[name]
	XHR.addEventListener 'load', (event) ->
		alert 'success'
	XHR.addEventListener 'error', (event) ->
		alert 'failure'

	XHR.open 'POST', 'http://morjo.coop.no/cp/'
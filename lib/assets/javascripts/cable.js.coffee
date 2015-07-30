#= require_self
#= require cable/consumer

@Cable =
  PING_IDENTIFIER: "_ping"

  createConsumer: (url) ->
    new Cable.Consumer @attachCsrfToken(url)

  attachCsrfToken: (url) ->
    token = document.querySelector("meta[name=csrf-token]")?.getAttribute("content")
    if token
      separator = if url.indexOf("?")>=0 then "&" else "?"
      url = "#{url}#{separator}token=#{encodeURIComponent(token)}"
    url

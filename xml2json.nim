import xmldom, xmldomparser, strutils, streams

proc norm(s: string): string =
  ## Replaces all characters other than A-Z, a-z, 0-9 and space with _
  ##
  result = ""
  for i in 0..len(s) - 1:
    if s[i] in {'A'..'Z'} or  s[i] in {'a'..'z'} or  s[i] in {'0'..'9'} or s[i] == ' ':
      add result, substr(s, i, i)
    else:
      add result, "_"
  return result
      
proc writePNode(node: PNode, sc: int = 1) =
  ## Write out the indented JSON corresponding to a PNode
  ##
  ## _writeJSON resursively visits all the nodes and writes out the
  ## JSON.

  var prefix = repeat(" ", sc)

  if node.hasChildNodes and node.firstChild.nodeType == TextNode:
    echo prefix, "\"$1\": \"$2\"" % [node.nodeName, norm node.firstChild.PText.data]
    return

  if not node.hasChildNodes: 
    echo prefix, "\"$1\": \"\"" % node.nodeName
    return

  echo prefix, "\"$1\": " % node.nodeName

  if node.hasChildNodes:
    prefix = repeat(" ", sc + 1)
    var fc = node.firstChild
    var lc = node.lastChild
    echo prefix, "{"
    writePNode(fc, sc+1)
    if fc == lc:
      echo prefix, "}"
      return
    var ns = fc.nextSibling
    while true:
      echo prefix, ","
      writePNode(ns, sc+1)
      if ns == lc: break
      ns = ns.nextSibling
    echo prefix, "}"

proc writeJSON*(xmlFileStream: FileStream) =
  var document = loadXMLStream(xmlFileStream)
  var rootTag = document.documentElement.nodeName
  var rootElements = document.getElementsByTagName(rootTag)
  echo "{"
  writePNode(rootElements[0])
  echo "}"

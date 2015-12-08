import os, streams, strutils, xml2json

var xmlFileName = paramStr(1)
var xmlFileStream = newFileStream(xmlFileName)
if xmlFileStream == nil: quit("Cannot open file $1" % xmlFileName)

writeJSON(xmlFileStream)

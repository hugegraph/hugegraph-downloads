#!/bin/bash

ROOT_PATH=docs
OUTPUT=index.html
FILTER_FILES=[html,sh,jpg,jpeg,ico,png]

function scandir(){
  local parent=$1
  if [ -n "$parent" ]; then
      parent="$parent/"
  fi
  # scan files
  for file in `ls $parent`; do
    local path="$parent$file"
    local ext=${file##*.}
    if [[ " ${FILTER_FILES[*]} " == *"$ext"* ]]; then
        echo Skipping $file ...
    elif [ -f "$path" ]; then
        local size=`du -sh $path | awk '{print $1}'`
        echo '    <li>' >> $OUTPUT
        echo '      <a href="'$path'">'$path'</a>' >> $OUTPUT
        echo '      <span style="font-size:12px;color:#909090"> '$size'</span>' >> $OUTPUT
        echo '    </li>' >> $OUTPUT
    fi
  done
  # scan dirs
  for file in `ls $parent`; do
    local path="$parent$file"
    if [ -d "$path" ]; then
        echo '    <br/>' >> $OUTPUT
        scandir "$path"
    fi
  done
}

cd $ROOT_PATH

# header
echo '<!DOCTYPE html><html>
<head>
  <meta charset="UTF-8">
  <title>HugeGraph downloads</title>
  <style type="text/css">
    body,td,th {
      font-family: Verdana,Arial,Helvetica,sans-serif;
      font-size: 15px;
      color: #1d1007;
      line-height: 24px;
    }

    html, body {
      height: 100%;
    }
 
    .wrapper {
      position: relative;
      min-height: calc(100% - 32px);
      padding-bottom: 32px;
      box-sizing: border-box;
    }

    .footer {
      position: absolute;
      bottom: 0;
      height: 32px;
      width: 100%;
      text-align: center;
      line-height: 32px;
      font-size: 14px;
    }
  </style>
  <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon">
</head>
<body> <div class="wrapper">
<div class="content">
  <div>
    <a href="https://hugegraph.github.io/hugegraph-doc/"><img src="images/logo.png" style="vertical-align:middle;" height="32" alt="HugeGraph Database"/></a>
    <span style="font-size:28px;vertical-align:middle">HugeGraph downloads</span>
  </div>
  <ul>' > $OUTPUT

# body
scandir

# footer
echo '
  </ul>
</div>
<div class="footer">
  <p>Contact information: <a href="mailto:hugegraph@googlegroups.com">hugegraph@googlegroups.com</a></p>
</div>
</div>
</body>
</html>' >> $OUTPUT

echo Successfully generated downloads file: $OUTPUT
